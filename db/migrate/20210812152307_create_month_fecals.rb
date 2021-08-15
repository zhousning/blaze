class CreateMonthFecals < ActiveRecord::Migration
  def change
    create_table :month_fecals do |t|
    
      t.integer :up_std,  null: false, default: Setting.systems.default_num 
    
      t.integer :end_std,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
