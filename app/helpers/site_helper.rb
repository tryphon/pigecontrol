module SiteHelper

  def site_information_tag
    unless Site.default.information.blank?
      content_tag(:p, Site.default.information)
    end
  end

end
