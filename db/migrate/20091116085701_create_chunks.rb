class CreateChunks < ActiveRecord::Migration
  def self.up
    create_table :chunks do |t|
      t.datetime :begin, :end
      t.float :completion_rate
      t.belongs_to :source

      t.timestamps
    end
  end

  def self.down
    drop_table :chunks
  end
end
