class AddUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :source, :string
  end
end
