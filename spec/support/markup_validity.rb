begin 
  require 'markup_validity'

  def with_markup_validity(&block)
    yield
  end
rescue Nokogiri::XML::SyntaxError
  puts "WARNING: markup_validity not available (check network connectivity ?)"
  def with_markup_validity(&block)
    pending "markup_validity is disabled"
  end
end

