class CreateMudfcts < ActiveRecord::Migration
  def change
    create_table :mudfcts do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.float :ability,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
