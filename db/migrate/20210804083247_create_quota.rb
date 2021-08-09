class CreateQuota < ActiveRecord::Migration
  def change
    create_table :quota do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :code,  null: false, default: Setting.systems.default_str
    
      t.string :ctg,  null: false, default: Setting.systems.default_str
      
      t.float :max

      t.float :min
    
    

    
      t.timestamps null: false
    end
  end
end
