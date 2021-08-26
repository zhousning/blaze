class CreateTspmuds < ActiveRecord::Migration
  def change
    create_table :tspmuds do |t|
    
      t.float :tspvum,  null: false, default: Setting.systems.default_num 
    
      t.string :dealer,  null: false, default: Setting.systems.default_str
    
      t.float :rcpvum,  null: false, default: Setting.systems.default_num 
    
      t.float :price,  null: false, default: Setting.systems.default_num 
    
      t.string :prtmtd,  null: false, default: Setting.systems.default_str
    
      t.string :goort,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :day_pdt
    
      t.references :day_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
