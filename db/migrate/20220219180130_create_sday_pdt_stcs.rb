class CreateSdayPdtStcs < ActiveRecord::Migration
  def change
    create_table :sday_pdt_stcs do |t|

      t.float :bom,  null: false, default: Setting.systems.default_num 

      t.float :water_bom,  null: false, default: Setting.systems.default_num 
    

      t.references :sday_pdt
    
      t.timestamps null: false
    end
  end
end
