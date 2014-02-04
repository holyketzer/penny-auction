class AddStartTimeToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :start_time, :datetime
  end
end
