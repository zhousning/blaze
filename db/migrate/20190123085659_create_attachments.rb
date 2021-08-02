class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.timestamps null: false

      t.string :file,  null: false, default: ""
      t.references :dog
      t.references :dog
      t.references :dog
      t.references :dog
      t.references :dog
      t.references :dog
    end
  end
end
