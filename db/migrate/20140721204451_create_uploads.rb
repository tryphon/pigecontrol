class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :file
      t.string :status
      t.datetime :retry_at
      t.integer :retry_count

      t.string :type

      t.integer :account_id

      t.string :target

      t.timestamps
    end
  end
end
