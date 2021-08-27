class CreateDayPdtRpts < ActiveRecord::Migration
  def change
    create_table :day_pdt_rpts do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.date :pdt_date
    
      t.string :weather,  null: false, default: Setting.systems.default_str
    
      t.float :temper,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_bod,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_cod,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_ss,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_tn,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_tp,  null: false, default: Setting.systems.default_num 
    
      t.float :inf_qlty_ph,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_cod,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_ss,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_tn,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_tp,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_ph,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_fecal,  null: false, default: Setting.systems.default_num 
    
      t.float :eff_qlty_bod,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_bod,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_cod,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_ss,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_tn,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_tp,  null: false, default: Setting.systems.default_num 
    
      t.float :sed_qlty_ph,  null: false, default: Setting.systems.default_num 
    
      t.float :inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :outflow,  null: false, default: Setting.systems.default_num 
    
      t.float :inmud,  null: false, default: Setting.systems.default_num 
    
      t.float :outmud,  null: false, default: Setting.systems.default_num 
    
      t.float :mst,  null: false, default: Setting.systems.default_num 
    
      t.float :power,  null: false, default: Setting.systems.default_num 
    
      t.float :mdflow,  null: false, default: Setting.systems.default_num 
    
      t.float :mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :mdsell,  null: false, default: Setting.systems.default_num 
    
      t.float :per_cost,  null: false, default: Setting.systems.default_num 
    

    
      t.references :day_pdt
    
      t.references :factory
    

    
      t.references :user
    
      t.timestamps null: false
    end
  end
end
