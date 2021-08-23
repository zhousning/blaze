class CreateDayRptStcs < ActiveRecord::Migration
  def change
    create_table :day_rpt_stcs do |t|
    
      t.float :bcr,  null: false, default: Setting.systems.default_num 
    
      t.float :bnr,  null: false, default: Setting.systems.default_num 
    
      t.float :bpr,  null: false, default: Setting.systems.default_num 
    
      t.float :bom,  null: false, default: Setting.systems.default_num 
    
      t.float :cod_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :bod_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :tp_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :tn_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :ss_bom,  null: false, default: Setting.systems.default_num 
    
      t.float :cod_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :bod_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :tp_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :tn_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :ss_emq,  null: false, default: Setting.systems.default_num 
    
      t.float :cod_emr,  null: false, default: Setting.systems.default_num 
    
      t.float :bod_emr,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn_emr,  null: false, default: Setting.systems.default_num 
    
      t.float :tp_emr,  null: false, default: Setting.systems.default_num 
    
      t.float :tn_emr,  null: false, default: Setting.systems.default_num 
    
      t.float :ss_emr,  null: false, default: Setting.systems.default_num 
    

    

    

    
      t.references :day_pdt_rpt
    

    
      t.timestamps null: false
    end
  end
end
