# frozen_string_literal: true

require "spec_helper"

describe(DNote::Notes) do
  let(:line) { "# TODO: Do something or another!" }
  let(:file) { "foo.rb" }
  let(:lineno) { 1 }
  let(:todo_hash) do
    {
      "label" => "TODO",
      "file" => file,
      "line" => lineno,
      "text" => "Do something or another!"
    }
  end

  describe("#labels") do
    it("returns the list of labels") do
      notes = described_class.new([], labels: ["TODO"])
      expect(notes.labels).to eq(["TODO"])
    end
  end

  describe("#files") do
    it("returns the files attribute") do
      notes = described_class.new([file])
      expect(notes.files).to eq([file])
    end
  end

  describe "#match_general" do
    it "matches a line with any label" do
      notes = described_class.new([])
      rec = notes.match_general(line, lineno, file)
      expect(rec.to_h).to eq todo_hash
    end

    it "does not match a line without a label" do
      notes = described_class.new([])
      rec = notes.match_general("# Just a comment", lineno, file)
      expect(rec.to_h).to eq({})
    end
  end

  describe "#match_special" do
    it "matches a line with any of the given labels" do
      notes = described_class.new([], labels: %w[TODO FIXME])
      rec = notes.match_special(line, lineno, file)
      expect(rec.to_h).to eq todo_hash
    end

    it "does not match a line with a label that is not listed" do
      notes = described_class.new([], labels: %w[FIXME HACK])
      rec = notes.match_special(line, lineno, file)
      expect(rec.to_h).to eq({})
    end
  end
end
