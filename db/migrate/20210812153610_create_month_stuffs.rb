class CreateMonthStuffs < ActiveRecord::Migration
  def change
    create_table :month_stuffs do |t|
    
      t.float :xdjtjl,  null: false, default: Setting.systems.default_num 
    
      t.float :end_xdjtjl,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
