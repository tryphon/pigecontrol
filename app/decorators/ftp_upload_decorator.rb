class FtpUploadDecorator < UploadDecorator
  delegate_all

  def target
    unless (target = object.target).size > 10
      "...#{target.from(-10)}"
    else
      target
    end
  end

  def target_url
    target_uri.to_s
  end

  def link_url
    File.dirname target_url
  end

end
