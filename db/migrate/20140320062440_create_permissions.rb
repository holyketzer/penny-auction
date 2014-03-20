class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :action
      t.string :subject
      t.integer :subject_id

      t.timestamps
    end

    create_table :role_permissions do |t|
      t.references :role, index: true
      t.references :permission, index: true

      t.timestamps
    end
  end
end
