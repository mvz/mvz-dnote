# frozen_string_literal: true

require "spec_helper"

describe(DNote::Format) do
  let(:notes) { instance_double DNote::NotesCollection, empty?: false }
  let(:note) do
    instance_double(DNote::Note,
                    text: "Foo Text", file: "file", line: 1, code?: false)
  end
  let(:format_name) { "text" }
  let(:format) { described_class.new(notes, format: format_name) }

  describe "#render" do
    before do
      allow(notes).to receive_messages(by_label: {"TODO" => [note]},
                                       counts: {"TODO" => 1})
    end

    it "renders the note text" do
      expect { format.render }.to output(/Foo Text/).to_stdout
        .and output(/1 TODOs/).to_stderr
    end
  end
end
