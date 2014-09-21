class Label < ActiveRecord::Base

  belongs_to :source
  validates_presence_of :name, :timestamp, :source_id

  attr_accessible :name, :timestamp

  after_initialize :set_default_timestamp

  def set_default_timestamp
    self.timestamp = Time.zone.now if timestamp.blank?
  end

  def date
    timestamp.to_date
  end

  @@blank_expression = /\A[\W_]*\z/
  cattr_accessor :blank_expression
  
  def blank?
    name =~ blank_expression if blank_expression
  end
  validate :validate_not_blank

  def validate_not_blank
    errors.add :name, :blank if blank?
  end

  @@max_label_count = 5000
  cattr_accessor :max_label_count

  after_create :check_label_count

  def check_label_count
    if max_label_count and Label.count > max_label_count
      old_label_ids = Label.order("timestamp desc").offset(max_label_count * 0.95).pluck(:id)
      Rails.logger.info "Purge last #{old_label_ids.size} oldest Labels"
      # ActiveRecord::ActiveRecordError: delete_all doesn't support offset scope
      Label.delete_all id: old_label_ids
    end
  end

end
