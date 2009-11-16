class CreateDefaultSource < ActiveRecord::Migration
  def self.up
    Source.create! :name => 'default'
  end

  def self.down
    if source = Source.find_by_name('default')
      source.destroy
    end
  end
end
