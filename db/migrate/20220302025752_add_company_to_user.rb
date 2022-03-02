class AddCompanyToUser < ActiveRecord::Migration
  def change
    add_column :users, :ccompany_id, :integer
    add_column :users, :ncompany_id, :integer
  end
end
