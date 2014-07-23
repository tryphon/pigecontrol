class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name

      t.string :type
      t.string :url
      t.string :credential

      t.timestamps
    end
  end
end
