class CreateCompetitors < ActiveRecord::Migration
  def self.up
    create_table :competitors do |t|
      
      t.string :name
      
      t.string :search_page
      t.string :search_link_selector
      t.string :search_name_selector
      t.string :search_price_selector
      t.string :search_special_price_selector

      t.timestamps
    end
  end

  def self.down
    drop_table :competitors
  end
end
