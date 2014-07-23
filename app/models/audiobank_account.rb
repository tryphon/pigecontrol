class AudiobankAccount < Account

  def remote_account
    @remote_account ||= Audiobank::Account.new credential
  end

  delegate :document, :documents, :to => :remote_account

  def upload(attributes = {})
    attributes = { :file => attributes } if attributes.is_a?(String)
    AudiobankUpload.create attributes.merge(:account => self)
  end

end
