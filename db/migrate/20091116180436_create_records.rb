class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.datetime :begin, :end
      t.string :filename
      t.belongs_to :source

      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
