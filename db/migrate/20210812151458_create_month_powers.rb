class CreateMonthPowers < ActiveRecord::Migration
  def change
    create_table :month_powers do |t|
    
      t.float :power,  null: false, default: Setting.systems.default_num 
    
      t.float :end_power,  null: false, default: Setting.systems.default_num 
    
      t.float :bom,  null: false, default: Setting.systems.default_num 
    
      t.float :bom_power,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
