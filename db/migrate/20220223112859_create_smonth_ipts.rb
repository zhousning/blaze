class CreateSmonthIpts < ActiveRecord::Migration
  def change
    create_table :smonth_ipts do |t|
    
      t.float :val,  null: false, default: Setting.systems.default_num 
    
      t.float :end_val,  null: false, default: Setting.systems.default_num 
    
      t.float :max_val,  null: false, default: Setting.systems.default_num 
    
      t.float :min_val,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_val,  null: false, default: Setting.systems.default_num 
    
      t.date :max_date
    
      t.date :min_date
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :smth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
