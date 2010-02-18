require 'pathname'
require 'dnote/note'

module DNote

  # = Developer Notes
  #
  # This class goes through you source files and compiles a list
  # of any labeled comments. Labels are all-cap single word prefixes
  # to a comment ending in a colon.
  #
  # Special labels do require the colon. By default these are +TODO+,
  # +FIXME+, +OPTIMIZE+ and +DEPRECATE+.
  #
  #--
  #   TODO: Add ability to read header notes. They often
  #         have a outline format, rather then the single line.
  #++
  class Notes
    include Enumerable

    # Default paths (all ruby scripts).
    DEFAULT_PATHS  = ["**/*.rb"]

    # Default note labels to look for in source code. (NOT CURRENTLY USED!)
    DEFAULT_LABELS = ['TODO', 'FIXME', 'OPTIMIZE', 'DEPRECATE']

    # Files to search for notes.
    attr_accessor :files

    # Labels to document. Defaults are: +TODO+, +FIXME+, +OPTIMIZE+ and +DEPRECATE+.
    attr_accessor :labels

    # Require label colon? Default is +true+.
    attr_accessor :colon

    # New set of notes for give +files+ and optional special labels.
    def initialize(files, options={})
      @files  = [files].flatten
      @labels = [options[:labels]].flatten.compact
      @colon  = options[:colon].nil? ? true : options[:colon]
      parse
    end

    # Array of notes.
    def notes
      @notes
    end

    # Notes counts by label.
    def counts
      @counts ||= (
        h = {}
        by_label.each do |label, notes|
          h[label] = notes.size
        end
        h
      )
    end

    # Iterate through notes.
    def each(&block)
      notes.each(&block)
    end

    # No notes?
    def empty?
      notes.empty?
    end

    # Gather notes.
    #--
    # TODO: Play gold with Notes#parse.
    #++
    def parse
      records = []
      files.each do |fname|
        next unless File.file?(fname)
        #next unless fname =~ /\.rb$/      # TODO: should this be done?
        File.open(fname) do |f|
          lineno, save, text = 0, nil, nil
          while line = f.gets
            lineno += 1
            save = match(line, lineno, fname)
            if save
              #file = fname
              text = save.text
              #save = {'label'=>label,'file'=>file,'line'=>line_no,'note'=>text}
              records << save
            else
              if text
                if line =~ /^\s*[#]{0,1}\s*$/ or line !~ /^\s*#/ or line =~ /^\s*#[+][+]/
                  text.strip!
                  text = nil
                else
                  if text[-1,1] == "\n"
                    text << line.gsub(/^\s*#\s*/,'')
                  else
                    text << "\n" << line.gsub(/^\s*#\s*/,'')
                  end
                end
              end
            end
          end
        end
      end

      @notes  = records.sort
    end

    #
    def match(line, lineno, file)
      if labels.empty?
        match_general(line, lineno, file)
      else
        match_special(line, lineno, file)
      end
    end

    # Match special notes.
    def match_special(line, lineno, file)
      rec = nil
      labels.each do |label|
        if md = match_special_regex(label).match(line)
          text = md[1]
          #rec = {'label'=>label,'file'=>file,'line'=>lineno,'note'=>text}
          rec = Note.new(file, label, lineno, text)
        end
      end
      rec
    end

    #--
    # TODO: ruby-1.9.1-p378 reports: `match': invalid byte sequence in UTF-8 
    #++
    def match_special_regex(label)
      if colon
        /\#\s*#{Regexp.escape(label)}[:]\s*(.*?)$/
      else
        /\#\s*#{Regexp.escape(label)}[:]?\s*(.*?)$/
      end
    end

    # Match notes that are labeled with a colon.
    def match_general(line, lineno, file)
      rec = nil
      if md = match_general_regex.match(line)
        label, text = md[1], md[2]
        #rec = {'label'=>label,'file'=>file,'line'=>lineno,'note'=>text}
        rec = Note.new(file, label, lineno, text)
      end
      return rec
    end

    #
    def match_general_regex
      if colon
        /\#\s*([A-Z]+)[:]\s+(.*?)$/
      else
        /\#\s*([A-Z]+)[:]?\s+(.*?)$/
      end
    end

    # Organize notes into a hash with labels for keys.
    def by_label
      @by_label ||= (
        list = {}
        notes.each do |note|
          list[note.label] ||= []
          list[note.label] << note
          list[note.label].sort #!{ |a,b| a.line <=> b.line }
        end
        list
      )
    end

    # Organize notes into a hash with filename for keys.
    def by_file
      @by_file ||= (
        list = {}
        notes.each do |note|
          list[note.file] ||= []
          list[note.file] << note
          list[note.file].sort! #!{ |a,b| a.line <=> b.line }
        end
        list
      )
    end

    # Organize notes into a hash with labels for keys, followed
    # by a hash with filename for keys.
    def by_label_file
      @by_label ||= (
        list = {}
        notes.each do |note|
          list[note.label] ||= {}
          list[note.label][note.file] ||= []
          list[note.label][note.file] << note
          list[note.label][note.file].sort! #{ |a,b| a.line <=> b.line }
        end
        list
      )
    end

    # Organize notes into a hash with filenames for keys, followed
    # by a hash with labels for keys.
    def by_file_label
      @by_file ||= (
        list = {}
        notes.each do |note|
          list[note.file] ||= {}
          list[note.file][note.label] ||= []
          list[note.file][note.label] << note
          list[note.file][note.label].sort! #{ |a,b| a.line <=> b.line }
        end
        list
      )
    end

    # Convert to an array of hashes.
    def to_a
      notes.map{ |n| n.to_h }
    end

    # Same as #by_label.
    def to_h
      by_label
    end

    # Convert to array of hashes then to YAML.
    #def to_yaml
    #  require 'yaml'
    #  to_a.to_yaml
    #end

    # Convert to array of hashes then to JSON.
    #def to_json
    #  begin
    #    require 'json'
    #  rescue LoadError
    #    require 'json_pure'
    #  end
    #  to_a.to_json
    #end

    # Convert to array of hashes then to a SOAP XML envelope.
    #def to_soap
    #  require 'soap/marshal'
    #  SOAP::Marshal.marshal(to_a)
    #end

    # XOXO microformat.
    #--
    # TODO: Would to_xoxo be better organized by label and or file?
    #++
    #def to_xoxo
    #  require 'xoxo'
    #  to_a.to_xoxo
    #end

  end

end

