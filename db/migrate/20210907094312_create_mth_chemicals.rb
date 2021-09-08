class CreateMthChemicals < ActiveRecord::Migration
  def change
    create_table :mth_chemicals do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.float :unprice,  null: false, default: Setting.systems.default_num 

      t.float :dosage,  null: false, default: Setting.systems.default_num 

      t.float :avg_dosage,  null: false, default: Setting.systems.default_num 

      t.float :act_dosage,  null: false, default: Setting.systems.default_num 
    
      t.float :cmptc,  null: false, default: Setting.systems.default_num 
    
      t.float :dosptc,  null: false, default: Setting.systems.default_num 
    
      t.float :per_cost,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :mth_pdt_rpt
    
    
      t.timestamps null: false
    end
  end
end
