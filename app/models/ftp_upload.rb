require 'net/ftp'

class FtpUpload < Upload

  def upload!
    ftp = Net::FTP.new
    Rails.logger.info "Connect to #{target_uri.host}:#{target_uri.port}"
    ftp.connect target_uri.host, target_uri.port

    Rails.logger.info "Upload #{file} to #{target_uri}"

    begin
      # ftp.debug_mode = true
      ftp.login
      ftp.chdir File.dirname(target_uri.path)
      # ftp.resume = true
      ftp.passive = true
      ftp.putbinaryfile file, File.basename(target_uri.path) do |buf|
        raise "Upload is aborted" unless uploading?
      end
    ensure
      ftp.close
    end

    Rails.logger.info "Upload #{target_uri} finished"

    true
  end

  def set_default_target
    self.target ||= File.basename(file) if file
  end

  def target_uri
    @target_uri ||= URI("#{account.url}/#{target}")
  end

end
