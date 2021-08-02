class CreateUserDepts < ActiveRecord::Migration
  def change
    create_table :user_depts do |t|
      t.references :user_id
      t.references :department_id

      t.timestamps null: false
    end
  end
end
