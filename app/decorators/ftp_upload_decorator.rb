class FtpUploadDecorator < UploadDecorator
  delegate_all

  def target
    if target_url.size > 20
      "...#{target_url.from(-20)}"
    else
      target_url
    end
  end

  def target_url
    object.target_uri.to_s
  end

  def link_url
    File.dirname target_url
  end

end
