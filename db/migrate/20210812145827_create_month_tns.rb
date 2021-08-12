class CreateMonthTns < ActiveRecord::Migration
  def change
    create_table :month_tns do |t|
    
      t.float :avg_inf,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_eff,  null: false, default: Setting.systems.default_num 
    
      t.float :emr,  null: false, default: Setting.systems.default_num 
    
      t.float :avg_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :emq,  null: false, default: Setting.systems.default_num 
    
      t.float :end_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :up_std,  null: false, default: Setting.systems.default_num 
    
      t.float :end_std,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
