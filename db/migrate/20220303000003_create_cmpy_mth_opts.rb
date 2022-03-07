class CreateCmpyMthOpts < ActiveRecord::Migration
  def change
    create_table :cmpy_mth_opts do |t|
    
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
    

    

    

    
      t.references :cmpy_mth_rpt
    

    
      t.timestamps null: false
    end
  end
end
