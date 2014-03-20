class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :action
      t.string :subject
      t.integer :subject_id
      t.references :role, index: true

      t.timestamps
    end
  end
end
