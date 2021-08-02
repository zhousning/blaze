class CreatePdtSums < ActiveRecord::Migration
  def change
    create_table :pdt_sums do |t|
    
      t.float :inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :outflow,  null: false, default: Setting.systems.default_num 
    
      t.float :inmud,  null: false, default: Setting.systems.default_num 
    
      t.float :outmud,  null: false, default: Setting.systems.default_num 
    
      t.float :mst,  null: false, default: Setting.systems.default_num 
    
      t.float :power,  null: false, default: Setting.systems.default_num 
    
      t.float :mdflow,  null: false, default: Setting.systems.default_num 
    
      t.float :mdrcy,  null: false, default: Setting.systems.default_num 
    
      t.float :mdsell,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :day_pdt
    

    
      t.timestamps null: false
    end
  end
end
