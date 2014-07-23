class FtpAccount < Account

  def upload(attributes = {})
    attributes = { :file => attributes } if attributes.is_a?(String)
    FtpUpload.create attributes.merge(:account => self)
  end

end
