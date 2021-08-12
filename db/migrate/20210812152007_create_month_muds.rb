class CreateMonthMuds < ActiveRecord::Migration
  def change
    create_table :month_muds do |t|
    
      t.float :inmud,  null: false, default: Setting.systems.default_num 
    
      t.float :end_inmud,  null: false, default: Setting.systems.default_num 
    
      t.float :outmud,  null: false, default: Setting.systems.default_num 
    
      t.float :end_outmud,  null: false, default: Setting.systems.default_num 
    
      t.float :mst_up,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
