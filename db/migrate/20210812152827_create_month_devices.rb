class CreateMonthDevices < ActiveRecord::Migration
  def change
    create_table :month_devices do |t|
    
      t.float :wsyxts,  null: false, default: Setting.systems.default_num 
    
      t.float :wswdyxts,  null: false, default: Setting.systems.default_num 
    
      t.float :sbwhl,  null: false, default: Setting.systems.default_num 
    
      t.float :gysbwhl,  null: false, default: Setting.systems.default_num 
    
      t.float :wbywhl,  null: false, default: Setting.systems.default_num 
    
      t.float :gzwwhl,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
