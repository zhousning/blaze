class CreateChemicalCtgs < ActiveRecord::Migration
  def change
    create_table :chemical_ctgs do |t|
    
      t.string :code,  null: false, default: Setting.systems.default_str
    
      t.string :name,  null: false, default: Setting.systems.default_str
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
