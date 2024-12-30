# frozen_string_literal: true

module DNote
  # = Notes Collection
  #
  # This class contains a collection of Note objects and can group them in
  # several ways.
  #
  class NotesCollection
    include Enumerable

    def initialize(notes)
      @notes = notes
    end

    # Array of notes.
    attr_reader :notes

    # Notes counts by label.
    def counts
      @counts ||=
        begin
          h = {}
          by_label.each do |label, notes|
            h[label] = notes.size
          end
          h
        end
    end

    # Iterate through notes.
    def each(&)
      notes.each(&)
    end

    # No notes?
    def empty?
      notes.empty?
    end

    # Organize notes into a hash with labels for keys.
    def by_label
      @by_label ||= notes.group_by(&:label)
    end

    # Organize notes into a hash with filename for keys.
    def by_file
      @by_file ||= notes.group_by(&:file)
    end

    # Organize notes into a hash with labels for keys, followed
    # by a hash with filename for keys.
    def by_label_file
      @by_label_file ||= by_label.transform_values { |notes| notes.group_by(&:file) }
    end

    # Organize notes into a hash with filenames for keys, followed
    # by a hash with labels for keys.
    def by_file_label
      @by_file_label ||= by_file.transform_values { |notes| notes.group_by(&:label) }
    end

    # Convert to an array of hashes.
    def to_a
      notes.map(&:to_h)
    end

    # Same as #by_label.
    def to_h
      by_label
    end
  end
end
