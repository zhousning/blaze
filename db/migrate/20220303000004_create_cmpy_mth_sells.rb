class CreateCmpyMthSells < ActiveRecord::Migration
  def change
    create_table :cmpy_mth_sells do |t|
    
      t.float :val,  null: false, default: Setting.systems.default_num 
    
      t.float :end_val,  null: false, default: Setting.systems.default_num 
    
      t.float :max_val,  null: false, default: Setting.systems.default_num 
    
      t.float :min_val,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_val,  null: false, default: Setting.systems.default_num 
      t.date :start_date

      t.date :end_date

    
      t.date :max_date
    
      t.date :min_date
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    
      t.integer :state,  null: false, default: Setting.systems.default_num 

      t.string :name,  null: false, default: Setting.systems.default_str

      t.references :ccompany

      t.references :ncompany
    
      t.references :cmpy_mth_rpt
    

      t.integer :category
    
      t.timestamps null: false
    end
  end
end
