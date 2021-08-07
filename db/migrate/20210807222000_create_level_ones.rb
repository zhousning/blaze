class CreateLevelOnes < ActiveRecord::Migration
  def change
    create_table :level_ones do |t|
    
      t.float :cod,  null: false, default: Setting.systems.default_num 
    
      t.float :bod,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :tn,  null: false, default: Setting.systems.default_num 
    
      t.float :tp,  null: false, default: Setting.systems.default_num 
    
      t.float :ss,  null: false, default: Setting.systems.default_num 
    
      t.integer :fecal,  null: false, default: Setting.systems.default_num 
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
