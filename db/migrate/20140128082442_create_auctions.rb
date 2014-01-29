class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.references :product, index: true
      t.references :image, index: true
      t.decimal :start_price, precision: 8, scale: 2
      t.decimal :min_price, precision: 8, scale: 2
      t.integer :duration
      t.integer :bid_time_step
      t.decimal :bid_price_step, precision: 8, scale: 2
    end
  end
end
