class CreateQuota < ActiveRecord::Migration
  def change
    create_table :quota do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.integer :code,  null: false, default: Setting.systems.default_num 
    
      t.integer :ctg,  null: false, default: Setting.systems.default_num 
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
