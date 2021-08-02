class CreateUserFcts < ActiveRecord::Migration
  def change
    create_table :user_fcts do |t|
      t.references :user_id
      t.references :factory_id

      t.timestamps null: false
    end
  end
end
