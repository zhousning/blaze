class UpdatePercostChemicals < ActiveRecord::Migration
  def change
    change_column :day_pdt_rpts, :per_cost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
    change_column :chemicals, :per_cost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
    change_column :mth_chemicals, :per_cost, :decimal, :precision => 10, :scale => 4,  null: false, :default => Setting.systems.default_num
  end
end
