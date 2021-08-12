class CreateMthPdtRpts < ActiveRecord::Migration
  def change
    create_table :mth_pdt_rpts do |t|

      t.date :pdt_date
    
      t.string :design,  null: false, default: Setting.systems.default_str
    
      t.string :outflow,  null: false, default: Setting.systems.default_str
    
      t.string :avg_outflow,  null: false, default: Setting.systems.default_str
    
      t.string :end_outflow,  null: false, default: Setting.systems.default_str

      t.references :factory
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
