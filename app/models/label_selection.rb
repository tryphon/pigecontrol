class LabelSelection
  include Enumerable

  attr_reader :labels
  protected :labels

  def initialize(label_identifiers = [])
    @labels =
      unless label_identifiers.blank?
        Label.find label_identifiers
      else
        []
      end
  end

  def each(&block)
    @labels.each(&block)
  end

  def ==(other)
    other and @labels == other.to_a
  end

  def add(label)
    @labels.clear if source and source != label.source
    @labels = [ label, *labels ].uniq.sort_by(&:timestamp).last(2)
    notify_on_change
  end
  alias_method :<<, :add

  def completed?
    labels.size == 2
  end

  delegate :empty?, :to => :labels

  def chunk
    unless empty?
      source.chunks.build :begin => labels.first.timestamp, :end => labels.last.timestamp
    end
  end

  def clear
    labels.clear
    notify_on_change
  end

  def source
    if label = labels.first
      label.source
    end
  end

  def same_source?(other)
    return false unless source and other

    other_source = other.respond_to?(:source) ? other.source : other
    source == other_source
  end

  def same_time_range?(other)
    return false unless time_range and other

    other_time_range = other.respond_to?(:time_range) ? other.time_range : other
    [:begin, :end].all? do |attribute|
      (time_range.send(attribute) - other_time_range.send(attribute)).abs < 1
    end
  end

  def on_change(&block)
    @on_change_handler = block
    self
  end

  def notify_on_change
    @on_change_handler.call labels if @on_change_handler
  end

  def begin
    labels.first
  end

  def end
    labels.last
  end

  def time_range
    if completed?
      Range.new(self.begin.timestamp, self.end.timestamp)
    end
  end

  def can_begin?(label)
    not completed? and
      (empty? or labels.first.timestamp > label.timestamp)
  end

  def can_end?(label)
    not completed? and
      (empty? or labels.first.timestamp < label.timestamp)
  end

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?
    false
  end

end
