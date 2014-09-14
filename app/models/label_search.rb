# coding: utf-8
class LabelSearch

  attr_accessor :term
  attr_accessor :before, :after, :on
  attr_accessor :per_page, :page

  attr_reader :scope

  def initialize(scope, options = {})
    @scope = scope

    options.each do |key, value|
      method = "#{key}="
      send method, value if respond_to?(method)
    end
  end

  @@max_per_page = 100
  cattr_accessor :max_per_page

  def per_page
    @per_page ||= 20
  end

  def per_page=(per_page)
    per_page = per_page.to_i
    @per_page = [[per_page, max_per_page].min, 1].max
  end

  def order
    'timestamp desc'
  end

  attr_accessor :now

  def now
    @now ||= Time.now
  end

  def on=(on)
    on = on.to_sym

    case on
    when :today
      self.after = now.beginning_of_day
    when :yesterday
      self.after, self.before = now.yesterday.beginning_of_day, now.yesterday.end_of_day
    else
      return
    end

    @on = on
  end

  %w{before after}.each do |time_attribute|
    define_method "#{time_attribute}=" do |value|
      value = Time.parse(value) if value.is_a? String
      return if value > now

      instance_variable_set "@#{time_attribute}", value
    end
  end

  def options
    values = %w{term before after on per_page page}.map do |attribute|
      value = send(attribute)
      [ attribute, value ] if value
    end.compact
    Hash[values]
  end

  def search
    Rails.logger.info "Search labels with #{options.inspect}"

    search_scope = scope
    search_scope = search_scope.where(["lower(name) like ?", "%#{term.downcase}%"]) if term.present?
    search_scope = search_scope.where(["timestamp < ?", before]) if before.present?
    search_scope = search_scope.where(["timestamp > ?", after]) if after.present?

    @labels ||= search_scope.paginate(page: page, per_page: per_page, order: order)
  end

end
