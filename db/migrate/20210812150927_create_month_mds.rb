class CreateMonthMds < ActiveRecord::Migration
  def change
    create_table :month_mds do |t|
    
      t.float :mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :end_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :end_mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy_mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr_mdsell,  null: false, default: Setting.systems.default_num 

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
