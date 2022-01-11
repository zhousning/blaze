class UpdateStcToDayRptStc < ActiveRecord::Migration
  def change
    change_column :day_rpt_stcs, :tp_cost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
    change_column :day_rpt_stcs, :tn_cost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
    change_column :day_rpt_stcs, :tp_utcost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
    change_column :day_rpt_stcs, :tn_utcost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
  end
end
