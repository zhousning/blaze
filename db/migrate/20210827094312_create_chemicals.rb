class CreateChemicals < ActiveRecord::Migration
  def change
    create_table :chemicals do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.float :unprice,  null: false, default: Setting.systems.default_num 
    
      t.float :cmptc,  null: false, default: Setting.systems.default_num 
    
      t.float :dosptc,  null: false, default: Setting.systems.default_num 
    
      t.float :per_cost,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :day_pdt_rpt
    
      t.references :day_pdt
    

    
      t.timestamps null: false
    end
  end
end
