require 'pronto/dialyzer/version'
require 'pronto'

module Pronto::Dialyzer
  class Runner < Pronto::Runner
    BEAM_EXTENSIONS = %w(.ex .erl).freeze

    def run
      return [] unless dialyzer_output_pathname.exist?
      beam_patches
        .select { |patch| patch.delta.status != :deleted }
        .flat_map { |patch| affected_lines(patch) }
    end

    def affected_lines(patch)
      candidate_lines = patch.lines.select { |line| line.addition? }
      candidate_lines.reduce([]) do |accum, line|
        affected_line = dialyzer_lines.find do |dline|
          patch.repo.path.join(dline.path) == patch.new_file_full_path &&
            dline.lineno == line.new_lineno
        end

        if affected_line
          accum << new_message(line, affected_line)
        else
          accum
        end
      end
    end

    def new_message(line, dline)
      Pronto::Message.new(dline.path, line, :warning, dline.error)
    end

    def beam_patches
      @patches.select do |patch|
        BEAM_EXTENSIONS.member?(File.extname(patch.new_file_full_path))
      end
    end

    def dialyzer_output_pathname
      @dialyzer_output_path ||= Pathname.new(
        ENV["PRONTO_DIALYZER_OUTPUT"] || "dialyzer.out"
      )
    end

    def dialyzer_lines
      @dialyzer_lines ||= matching_lines(
        dialyzer_output_pathname,
        /(?<path>.+\.[a-z]{2,3}):(?<lineno>[0-9]+): (?<error_msg>.+)/
      )
    end

    private

    def matching_lines(pathname, line_regex)
      pathname.readlines.reduce([]) do |accum, line|
        if match = line.match(line_regex)
          accum << OpenStruct.new(
            path: match[:path],
            lineno: match[:lineno].to_i,
            error: match[:error_msg]
          )
        else
          accum
        end
      end
    end
  end
end
