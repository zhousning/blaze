class CreateMonthMds < ActiveRecord::Migration
  def change
    create_table :month_mds do |t|
    
      t.decimal :mdrcy, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

      t.decimal :end_mdrcy, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num
    
      t.decimal :mdsell, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

      t.decimal :end_mdsell, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num
    
      t.float :yoy_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr_mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :yoy_mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :mom_mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :ypdr_mdsell,  null: false, default: Setting.systems.default_num 

    

    

    
      t.references :mth_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
