class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.decimal :price, precision: 8, scale: 2      
      t.references :user, index: true
      t.references :auction, index: true
    end
  end
end
