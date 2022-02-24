class CreateSmonthPowers < ActiveRecord::Migration
  def change
    create_table :smonth_powers do |t|
    
      t.float :val,  null: false, default: Setting.systems.default_num 

      t.float :new_val,  null: false, default: Setting.systems.default_num 
    
      t.float :end_val,  null: false, default: Setting.systems.default_num 

      t.float :avg_val,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    
      t.float :bom,  null: false, default: Setting.systems.default_num 
    
      t.float :end_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :mbom,  null: false, default: Setting.systems.default_num 
    
      t.float :end_mbom,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy_mbom,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_mbom,  null: false, default: Setting.systems.default_num 

    

    

    
      t.references :smth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
