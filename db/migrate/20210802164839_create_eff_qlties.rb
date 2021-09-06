class CreateEffQlties < ActiveRecord::Migration
  def change
    create_table :eff_qlties do |t|
    
      t.float :bod,  null: false, default: Setting.systems.default_num 
    
      t.float :cod,  null: false, default: Setting.systems.default_num 
    
      t.float :ss,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :tn,  null: false, default: Setting.systems.default_num 
    
      t.float :tp,  null: false, default: Setting.systems.default_num 
    
      t.float :ph,  null: false, default: Setting.systems.default_num 
    
      t.integer :fecal,  null: false, default: Setting.systems.default_num 
    
      t.float :asy_cod,  null: false, default: Setting.systems.default_num 
      t.float :asy_nhn,  null: false, default: Setting.systems.default_num 
      t.float :asy_tp,  null: false, default: Setting.systems.default_num 
      t.float :asy_tn,  null: false, default: Setting.systems.default_num 

   

    

    
      t.references :day_pdt
    

    
      t.timestamps null: false
    end
  end
end
