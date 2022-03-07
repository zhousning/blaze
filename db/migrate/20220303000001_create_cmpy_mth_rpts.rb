class CreateCmpyMthRpts < ActiveRecord::Migration
  def change
    create_table :cmpy_mth_rpts do |t|

      t.date :start_date

      t.date :end_date
    
      t.integer :state,  null: false, default: Setting.systems.default_num 

      t.string :name,  null: false, default: Setting.systems.default_str

      t.string :cmc_bill,  null: false, default: Setting.systems.default_str
    
      t.string :ecm_ans_rpt,  null: false, default: Setting.systems.default_str

      t.float :leakage,  null: false, default: Setting.systems.default_num 

      t.references :ccompany
      t.references :ncompany
    
      t.timestamps null: false
    end
  end
end
