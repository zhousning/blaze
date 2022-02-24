class CreateSdayPdts < ActiveRecord::Migration
  def change
    create_table :sday_pdts do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.date :pdt_date
    
      t.string :signer,  null: false, default: Setting.systems.default_str
    
      t.integer :state,  null: false, default: Setting.systems.default_num 
    
      t.string :weather,  null: false, default: Setting.systems.default_str
    
      t.float :min_temper,  null: false, default: Setting.systems.default_num 
    
      t.float :max_temper,  null: false, default: Setting.systems.default_num 
    
      t.text :desc
    
      t.string :one_verify,  null: false, default: Setting.systems.default_str
    
      t.string :two_verify,  null: false, default: Setting.systems.default_str
    
      t.float :ipt,  null: false, default: Setting.systems.default_num 
    
      t.float :opt,  null: false, default: Setting.systems.default_num 
    
      t.float :press,  null: false, default: Setting.systems.default_num 
    
      t.float :power,  null: false, default: Setting.systems.default_num 
    
      t.float :yl,  null: false, default: Setting.systems.default_num 
    
      t.float :zd,  null: false, default: Setting.systems.default_num 
    
      t.float :yd,  null: false, default: Setting.systems.default_num 
    
      t.float :ph,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :sfactory
    

    
      t.timestamps null: false
    end
  end
end
