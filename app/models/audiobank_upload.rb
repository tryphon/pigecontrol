class AudiobankUpload < Upload

  def upload!
    prepare_uploaded_file
    document.import uploaded_file
  end

  def prepare_uploaded_file
    return if File.exist? uploaded_file

    Rails.logger.debug "Compress #{file} in flac"
    Tempfile.open(["audiobank-upload-#{id}", ".flac"]) do |temp_file|
      temp_file.close

      system "sox #{file} #{temp_file.path}"
      FileUtils.mv temp_file.path, uploaded_file
    end
  end

  def uploaded_file
    if File.extname(file).downcase == ".wav"
      "#{File.dirname(file)}/.audiobank-upload-#{id}.flac"
    else
      file
    end
  end

  def set_default_target
    if self.target.nil? and File.basename(file) =~ /^([0-9]+)-/
      self.target = $1
    end
  end

  def document_id
    target.to_i if target
  end

  def document
    @document ||= (find_document or create_document)
  end

  def default_attributes
    {
      :title => File.basename(file, File.extname(file)),
      :description => "Uploaded at #{Time.now}"
    }
  end

  def find_document
    account.document(document_id) if document_id
  end

  def create_document
    account.documents.create(default_attributes).tap do |document|
      update_attribute :target, document.id
    end
  end

  def size
    if File.exist?(uploaded_file)
      File.size uploaded_file
    else
      super
    end
  end

end
