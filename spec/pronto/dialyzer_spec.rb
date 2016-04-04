require 'spec_helper'

describe Pronto::Dialyzer do
  it 'has a version number' do
    expect(Pronto::Dialyzer::VERSION).not_to be nil
  end

  describe Pronto::Dialyzer::Runner do
    let(:repo) {
      double(:repo,
             path: Pathname.new("."),
             blame: double(:blame, :[] => commit))
    }
    let(:commit) { "abc123" }
    let(:patches) { Pronto::Git::Patches.new(repo, commit, patches_array) }

    subject { described_class.new(patches) }

    describe "#beam_patches" do
      let(:patches_array) { [
        double(:elixir_patch, delta: double(new_file: {path: "spec/fixtures/test.ex"})),
        double(:ruby_patch, delta: double(new_file: {path: "spec/spec_helper.rb"})),
        double(:erlang_patch, delta: double(new_file: {path: "spec/fixtures/test.erl"})),
      ]}

      it 'selects files with .ex extension' do
        elixir_patch, erlang_patch = subject.beam_patches
        expect(File.extname(elixir_patch.new_file_full_path)).to eq ".ex"
        expect(File.extname(erlang_patch.new_file_full_path)).to eq ".erl"
      end
    end

    describe "#run" do
      let(:patches_array) { [
        double(:patch1,
               delta: double(
                 :delta1,
                 status: :deleted,
                 new_file: {path: "spec/fixtures/deleted.ex"})),
        double(:patch2,
               delta: double(
                 :delta2,
                 status: :added,
                 new_file: {path: "spec/fixtures/test.ex"}),
               hunks: [
                 double(:hunk,
                        lines: [double(:line, addition?: true, new_lineno: 2)])]
              )
      ]}

      context 'when dialyzer output does not exist' do
        it 'returns []' do
          expect(subject.run).to eq []
        end
      end

      context 'when dialyzer output exists' do
        before do
          ENV['PRONTO_DIALYZER_OUTPUT'] = "spec/fixtures/dialyzer.out"
        end

        it 'returns messages for the indicated dialyzer lines' do
          messages = subject.run
          message = messages.first
          expect(message.path).to eq("spec/fixtures/test.ex")
          expect(message.msg).to eq("ERROR")
          expect(message.commit_sha).to eq(commit)
          expect(messages.count).to eq(1)
        end
      end
    end

    describe ".dialyzer_lines" do
      before do
        ENV['PRONTO_DIALYZER_OUTPUT'] = "spec/fixtures/dialyzer.out"
      end

      it 'parses lines correctly' do
        affected_lines = described_class.dialyzer_lines
        expect(affected_lines.count).to eq 42
        expect(affected_lines).to include(
          OpenStruct.new(lineno: 2, path: "spec/fixtures/test.ex", error: "ERROR")
        )
      end
    end
  end
end
