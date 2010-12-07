module Sox

  @@logger = nil
  mattr_accessor :logger

  def self.command
    command = Command.new
    yield command
    command.run
  end

  #  Sox.command do |sox|
  #    sox.input "input1.wav"
  #    sox.input "input2", :type => "ogg"
  #    
  #    sox.output "output", :type => "ogg", :compression => 8
  #  end
  class Command

    attr_accessor :inputs, :effects
    attr_writer :output

    def initialize(&block)
      @inputs = []
      @effects = []
      yield self if block_given?
    end

    def input(filename, options = {})
      self.inputs << File.new(filename, options)
    end

    def output(*arguments)
      if arguments.empty?
        @output
      else
        self.output=File.new(*arguments)
      end
    end

    def effect(name, *arguments)
      self.effects << Effect.new(name, *arguments)
    end

    def command_line
      "sox #{command_arguments}"
    end

    def command_arguments
      returning([]) do |arguments|
        #arguments << inputs.collect(&:command_arguments)
        arguments << self.playlist_filename
        arguments << output.command_arguments
        arguments << effects.collect(&:command_arguments).join(' : ')
      end.flatten.delete_if(&:blank?).join(' ')
    end

    def create_playlist
      ::File.open(self.playlist_filename,"w") do |playlist|
        inputs.each do |input|
          playlist.puts input.filename
        end
      end
    end

    def playlist_filename
      "#{Dir.tmpdir}/#{self.id}.m3u"
    end

    def id
      @uuid ||= Time.now.usec
    end

    def delete_playlist
      ::File.delete self.playlist_filename
    end

    def run
      Sox.logger.debug "Run #{self.command_line}" if Sox.logger
      # creating the m3u playlist
      self.create_playlist
      success = false
      begin
        success = system self.command_line
      ensure
        # deleting m3u playlist
        self.delete_playlist
      end
      success
    end

    def run!
      raise "sox execution failed" unless run
    end

    class File 

      attr_accessor :filename, :options

      def initialize(filename, options = {})
        @filename = filename
        @options = options
      end

      def command_arguments
        unless options.empty?
          format_options = sorted_options.collect do |name, value|
            "--#{name} #{value}"
          end.join(' ') + " "
        end
        "#{format_options}#{self.filename}"
      end

      def sorted_options
        options.to_a.sort_by { |pair| pair.first.to_s }
      end

      def ==(other)
        other and 
          other.filename == filename and 
          other.options == options
      end

    end

    class Effect

      attr_accessor :name, :arguments

      def initialize(name, *arguments)
        @name = name
        @arguments = arguments
      end

      def ==(other)
        other and 
          other.name == name and 
          other.arguments == arguments
      end

      def command_arguments
        [ @name, *arguments].join(' ')
      end

    end

  end


end
