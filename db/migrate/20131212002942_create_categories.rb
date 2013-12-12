class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :ancestry

      t.timestamps
    end
    add_index :categories, :ancestry
  end
end
