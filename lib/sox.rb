module Sox

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

    attr_accessor :inputs
    attr_writer :output

    def initialize(&block)
      @inputs = []
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

    def command_line
      "sox #{command_arguments}"
    end

    def command_arguments
      (inputs + [output]).collect(&:command_arguments).join(' ')      
    end

    def run
      system self.command_line
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

  end


end
