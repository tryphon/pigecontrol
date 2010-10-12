module LinkToMatcher
  include Spec::Rails::Matchers
 
  def have_link_to(url, html_options = {})
    additionnal_selection = html_options.collect do |key, value|
      "[#{key}=#{value}]"
    end
    AssertSelect.new(:assert_select, self, "a[href=?]#{additionnal_selection}", url)
  end
end

Spec::Runner.configure do |config|
  config.include LinkToMatcher, :type => :view
  config.include LinkToMatcher, :type => :helper
end
