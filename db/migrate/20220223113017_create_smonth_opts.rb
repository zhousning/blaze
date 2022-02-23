class CreateSmonthOpts < ActiveRecord::Migration
  def change
    create_table :smonth_opts do |t|
    
      t.float :ipt,  null: false, default: Setting.systems.default_num 
    
      t.float :end_ipt,  null: false, default: Setting.systems.default_num 
    
      t.float :max_ipt,  null: false, default: Setting.systems.default_num 
    
      t.float :min_ipt,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_ipt,  null: false, default: Setting.systems.default_num 
    
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
