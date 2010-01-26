class Site

  @@default = Site.new
  cattr_accessor :default

  def self.config
    site = Site.new
    yield site
    self.default=site
  end

  attr_accessor :information

end
