class AddStdpowerToMonthPower < ActiveRecord::Migration
  def change
    add_column :month_powers, :stdpower, :decimal, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num
    add_column :month_powers, :dev_rate, :decimal, :precision => 10, :scale => 2,  null: false, :default => Setting.systems.default_num
  end
end
