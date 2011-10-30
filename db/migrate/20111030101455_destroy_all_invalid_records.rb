class DestroyAllInvalidRecords < ActiveRecord::Migration
  def self.up
    begin
      Record.destroy_all_invalid
    rescue => e
      Rails.logger.debug "Can't destroy invalid records : #{e}"
    end
  end

  def self.down
  end
end
