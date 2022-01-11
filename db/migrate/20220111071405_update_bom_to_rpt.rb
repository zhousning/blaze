class UpdateBomToRpt < ActiveRecord::Migration
  def change
    change_column :day_rpt_stcs, :bom, :decimal, :precision => 11, :scale => 3,  null: false, :default => Setting.systems.default_num
    change_column :month_powers, :bom, :decimal, :precision => 11, :scale => 3,  null: false, :default => Setting.systems.default_num
  end
end
