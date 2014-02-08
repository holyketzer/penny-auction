class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|      
      t.references :user, index: true
      t.references :auction, index: true
    end

    add_column :auctions, :price, :decimal, precision: 8, scale: 2
  end
end
