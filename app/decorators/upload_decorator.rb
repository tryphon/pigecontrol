class UploadDecorator < ApplicationDecorator
  delegate_all

  def status
    status = I18n.translate(object.status, :scope => "uploads.status", :default => object.status.capitalize, :retry_count => retry_count)
  end

  def type
    object.type.gsub "Upload", ""
  end

  def user_link_to
    h.link_to_if link_url, target, link_url, :title => target_url, :target => "_blank"
  end

  def try_count
    object.retry_count + 1
  end

end
