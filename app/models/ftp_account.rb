class FtpAccount < Account

  def upload(attributes = {})
    attributes = { :file => attributes } if attributes.is_a?(String)
    FtpUpload.create attributes.merge(:account => self)
  end

  def splitted_credential
    @splitted_credential ||= credential ? credential.split(':') : []
  end

  def user
    splitted_credential.first
  end

  def password
    splitted_credential.second
  end

end
