require 'pronto/dialyzer/version'
require 'pronto'

module Pronto::Dialyzer
  class Runner < Pronto::Runner

    def run
      return [] unless File.exists?(self.class.dialyzer_output_path)
      elixir_patches
        .select { |patch| patch.delta.status != :deleted }
        .flat_map { |patch| affected_lines(patch) }
    end

    def affected_lines(patch)
      candidate_lines = patch.lines.select { |line| line.addition? }
      candidate_lines.reduce([]) do |accum, line|
        affected_line = self.class.dialyzer_lines.find do |dline|
          patch.repo.path.join(dline.path) == patch.new_file_full_path && dline.lineno == line.new_lineno
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

    def elixir_patches
      @patches.select {|patch| File.extname(patch.new_file_full_path) == '.ex' }
    end

    def self.dialyzer_output_path
      ENV["PRONTO_DIALYZER_OUTPUT"] || "dialyzer.out"
    end

    def self.dialyzer_lines
      File.readlines(dialyzer_output_path).reduce([]) do |accum, line|
        match = line.match(/(.+\.ex):([0-9]+): (.+)/)
        if match
          accum << OpenStruct.new(path: match[1], lineno: match[2].to_i, error: match[3])
        else
          accum
        end
      end
    end
  end
end
