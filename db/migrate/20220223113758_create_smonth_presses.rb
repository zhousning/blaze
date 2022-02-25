class CreateSmonthPresses < ActiveRecord::Migration
  def change
    create_table :smonth_presses do |t|
    
      t.float :max_val,  null: false, default: Setting.systems.default_num 
    
      t.float :min_val,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_val,  null: false, default: Setting.systems.default_num 
    
      t.date :max_date
    
      t.date :min_date
    

    

    

    
      t.references :smth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
