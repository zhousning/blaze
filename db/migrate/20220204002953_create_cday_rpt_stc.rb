class CreateCdayRptStc < ActiveRecord::Migration
  def change
    create_table :cday_rpt_stcs do |t|
    
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
    
      t.float :cod_inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :bod_inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :nhn_inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :tp_inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :tn_inflow,  null: false, default: Setting.systems.default_num 
    
      t.float :ss_inflow,  null: false, default: Setting.systems.default_num 
    
      t.decimal :tp_cost,   :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

      t.decimal :tn_cost,   :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

      t.decimal :tp_utcost, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

      t.decimal :tn_utcost, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num

    
      t.references :day_pdt_rpt
    
      t.timestamps null: false
    end
  end
end
