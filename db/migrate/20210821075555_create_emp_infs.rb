class CreateEmpInfs < ActiveRecord::Migration
  def change
    create_table :emp_infs do |t|
    
      t.datetime :pdt_time
    
      t.float :cod,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn,  null: false, default: Setting.systems.default_num 
    
      t.float :tp,  null: false, default: Setting.systems.default_num 
      t.float :tn,  null: false, default: Setting.systems.default_num 
    
      t.float :flow,  null: false, default: Setting.systems.default_num 
    
      t.float :ph,  null: false, default: Setting.systems.default_num 
    
      t.float :temp,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
