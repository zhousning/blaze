class CreateUserSfcts < ActiveRecord::Migration
  def change
    create_table :user_sfcts do |t|
      t.integer :user_id
      t.integer :sfactory_id

      t.timestamps null: false
    end
  end
end
