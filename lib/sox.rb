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
      inputs << File.new(filename, options)
    end

    def output(*arguments)
      if arguments.empty?
        @output
      else
        self.output=File.new(*arguments)
      end
    end

    def effect(name, *arguments)
      effects << Effect.new(name, *arguments)
    end

    def command_line
      "sox #{command_arguments}"
    end

    def command_arguments
      returning([]) do |arguments|
        if playlist.useful?
          arguments << playlist.create
        else
          arguments << inputs.collect(&:command_arguments)
        end
        arguments << output.command_arguments
        arguments << effects.collect(&:command_arguments).join(' : ')
      end.flatten.delete_if(&:blank?).join(' ')
    end

    def playlist
      @playlist ||= Playlist.new(inputs)
    end

    def run
      Sox.logger.debug "Run #{command_line}" if Sox.logger

      begin
        system command_line
      ensure
        playlist.delete
      end
    end

    def run!
      raise "sox execution failed" unless run
    end

    class Playlist

      attr_accessor :inputs

      def initialize(inputs)
        @inputs = inputs
      end

      def file
        @file ||= Tempfile.new(['sox-command-playlist','.m3u'])
      end

      def path
        file.path
      end
      
      def create
        ::File.open(file.path,"w") do |playlist|
          inputs.each do |input|
            playlist.puts input.filename
          end
        end

        file.path
      end

      def delete
        if @file
          @file.close(true)
          @file = nil
        end
      end

      def useful?
        inputs.all? { |input| input.options.empty? } and
          inputs.sum { |i| i.filename.size } > 500
      end

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
        "#{format_options}#{filename}"
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
