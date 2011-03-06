require 'eventmachine'

module UDP::Receiver
  class Message
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def raw_name
      $1.strip if data =~ /label: (.*)$/
    end

    def name
      I18n.translate "labels.codes.#{raw_name}", :default => raw_name if raw_name.present?
    end

    def label
      Source.default.labels.build(:name => name)
    end

    def create_label
      if label.save
        true
      else
        Rails.logger.info "Can't create label from '#{data}'"
        false
      end
    end
  end
  
  def receive_data(data)
    Rails.logger.debug "Receive UDP message: #{data}"
    if Message.new(data).create_label
      Rails.logger.debug "Send acknowledgement"
      send_data("ACK")
    end
  rescue => e
    Rails.logger.error "Error while receiving UDP message '#{data}' : #{e}"
  end  

  def post_init
    Rails.logger.info "UDP receiver ready"
  end

  def unbind
    Rails.logger.info "UDP receiver stopped"
  end

  def self.init
    if defined?(PhusionPassenger)
      PhusionPassenger.on_event(:starting_worker_process) do |forked|
        start
      end
    else
      start
    end
  end

  def self.start(new_thread = true)
    Rails.logger.debug "Try to start a new UDP receiver"

    Thread.start do
      begin
        EventMachine::run do
          EventMachine::open_datagram_socket "0.0.0.0", 9999, UDP::Receiver  
        end
      rescue => e
        Rails.logger.debug "UDP receiver not started (#{e})"
      end
    end
  end

end
