class CreateSfactories < ActiveRecord::Migration
  def change
    create_table :sfactories do |t|
    
      t.string :area,  null: false, default: Setting.systems.default_str
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.text :info
    
      t.string :lnt,  null: false, default: Setting.systems.default_str
    
      t.string :lat,  null: false, default: Setting.systems.default_str
    
      t.float :design,  null: false, default: Setting.systems.default_num

      t.float :plan,  null: false, default: Setting.systems.default_num

    
      t.string :logo,  null: false, default: Setting.systems.default_str

      t.string :category,  null: false, default: Setting.systems.default_str
    

    

    
      t.references :company
      t.references :ccompany
      t.references :ncompany

    
    
      t.timestamps null: false
    end
  end
end
