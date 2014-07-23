class Upload < ActiveRecord::Base
  attr_accessible :file, :target, :account, :status, :retry_at

  belongs_to :account

  STATUSES = %w{waiting uploading retry done canceled}

  def retry!
    change_status 'retry'
  end

  def cancel!
    change_status 'canceled'
  end

  def pending?
    status.in? %{waiting uploading retry}
  end

  def change_status(status)
    self.status = status
    if status == 'retry'
      self.retry_at = 5.minutes.from_now
      self.retry_count += 1
    end
    save!
  end

  after_initialize :set_defaults

  def set_defaults
    self.status ||= "waiting"
    self.retry_count ||= 0
    set_default_target
  end

  def set_default_target
  end

  def uploading
    change_status 'uploading'
    self
  end

  def uploading?
    status == 'uploading'
  end

  def file_age
    Time.now - File.mtime(file)
  end

  def size
    File.size file if File.exist?(file)
  end

  def upload
    change_status 'uploading'

    success =
      begin
        upload!
      rescue Exception => e
        Rails.logger.debug "Upload #{self.inspect} failed : #{e}"
        false
      end

    change_status(success ? 'done' : 'retry')
  end

  def self.pending
    where(:status => %w{waiting retry}).where("retry_at is null or retry_at < ?", Time.now).order(:retry_count, :retry_at)
  end

  def self.retry_all!
    where(:status => "uploading").find_each(&:retry!)
  end

  def self.loop!(options = {})
    options = { :queue_count => 3 }.merge(options)

    queue_count = options[:queue_count]
    Parallel.in_processes(:count => queue_count) do |queue_id|
      loop do
        begin
          pending_upload = Upload.transaction do
            Upload.pending.lock.first.try :uploading
          end

          if pending_upload
            if pending_upload.file_age < 30
              Rails.logger.debug "Queue #{queue_id} : File under modifications, wait for 30s"
              pending_upload.update_attributes :status => "waiting", :retry_at => 30.seconds.from_now
            else
              Rails.logger.debug "Queue #{queue_id} : Upload #{pending_upload.id}"
              pending_upload.upload
            end
          else
            Rails.logger.debug "Queue #{queue_id} : No pending upload, sleep"
            sleep 30 * (1 + rand)
          end
        rescue Exception => e
          Rails.logger.debug "Queue #{queue_id} : Error #{e}, sleep"
          sleep 30 * (1 + rand)
        end
      end
    end
  end

  @@watch_directory = "tmp/upload"
  cattr_accessor :watch_directory

  HIDDEN_FILES = %r{(^|/)\.[^/]+$}

  def self.watch
    listener = Listen.to(watch_directory, :ignore => HIDDEN_FILES, only: /\.(wav|flac|mp3|ogg)$/i) do |modified, added, removed|
      begin
        Rails.logger.debug "modified absolute path: #{modified}"
        Rails.logger.debug "added absolute path: #{added}"
        Rails.logger.debug "removed absolute path: #{removed}"

        (added + modified).each do |file|
          Account.all.each do |account|
            account.upload file
          end unless Upload.where(:file => file).exists?
        end

        Upload.where(:file => removed).destroy_all
      rescue Exception => e
        Rails.logger.error "Error in listening #{watch_directory}"
      end
    end
    listener.start
  end

  def self.daemon
    retry_all!
    watch
    loop!
  end

end
