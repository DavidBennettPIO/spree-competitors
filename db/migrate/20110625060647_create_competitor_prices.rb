class CreateCompetitorPrices < ActiveRecord::Migration
  def self.up
    create_table :competitor_prices do |t|
      
      t.references :competitor
      t.references :variant

      t.decimal :price
      t.decimal :special_price
    end
  end

  def self.down
    drop_table :competitor_prices
  end
end
