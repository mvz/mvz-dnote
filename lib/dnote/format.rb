module DNote

  # = Notes Formatter
  #
  #--
  #   TODO: Need good CSS file.
  #
  #   TODO: Need XSL?
  #++
  class Format

    require 'fileutils'
    require 'erb'
    require 'rexml/text'
    require 'dnote/string'

    #DEFAULT_OUTPUT_DIR = "log/dnote"

    EXTENSIONS = { 'soap'=>'xml', 'xoxo'=>'xml' }

    #
    attr :notes

    #
    attr_accessor :format

    #
    attr_accessor :output

    #
    attr_accessor :template

    #
    attr_accessor :title

    #
    attr_accessor :dryrun

    #
    def initialize(notes, options={})
      @notes  = notes
      @format = :gnu
      @title  = "Developer's Notes"
      options.each{ |k,v| __send__("#{k}=", v) if v }
      yield(self) if block_given?
    end

    #
    def render
      if notes.empty?
        $stderr << "No #{notes.labels.join(', ')} notes.\n"
      else
        case format
        when 'custom'
          render_custom
        else
          render_template
        end
      end
    end

    # C U S T O M

    #
    def render_custom
      #raise ArgumentError unless File.exist?(template)
      result = erb(template)
      publish(result)    
    end

    # T E M P L A T E

    #
    def render_template
      template = File.join(File.dirname(__FILE__), 'templates', "#{format}.erb")
      raise "No such file or directory - #{template}" unless File.exist?(template)
      result = erb(template)
      publish(result)  
    end

  private

    #
    def erb(file)
      scope = ErbScope.new(:notes=>notes, :title=>title)
      scope.render(file)
    end

    #
    def publish(result, fname=nil)
      if output
        write(result, fname)
      else
        puts(result)
      end
      $stderr << "(" + notes.counts.map{|l,n| "#{n} #{l}s"}.join(', ') + ")\n"
    end

    #
    def write(result, fname=nil)
      if output.end_with?('/') || File.directory?(output)
        ext  = EXTENSIONS[format] || format
        file = File.join(output, fname || "notes.#{ext}")
      else
        file = output
      end
      if dryrun?
        puts "mkdir: #{File.dirname(file)}"
        puts "write: #{file}"
      else
        dir = File.dirname(file)
        fu.mkdir(dir) unless File.exist?(dir)
        File.open(file, 'w'){ |f| f << result }
      end
      return file
    end

    #
    def dryrun?
      @dryrun
    end

    #
    def debug?
      $DEBUG
    end

    #
    def fu
      @fu ||= (
        if dryrun? and debug?
          FileUtils::DryRun
        elsif dryrun?
          FileUtils::Noop
        elsif debug?
          FileUtils::Verbose
        else
          FileUtils
        end
      )
    end

    #
    class ErbScope 
      #
      def initialize(data={})
        @data = data
      end
      #
      def render(file)
        erb = ERB.new(File.read(file), nil, '<>')
        erb.result(binding)
      end
      #
      def h(string)
        REXML::Text.normalize(string)
      end
      #
      def method_missing(s, *a)
        @data[s.to_sym]
      end
    end

  end

end
