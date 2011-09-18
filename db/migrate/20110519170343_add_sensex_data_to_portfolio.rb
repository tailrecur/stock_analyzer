class AddSensexDataToPortfolio < ActiveRecord::Migration
  def self.up
    change_table :portfolios do |t|
      t.integer :sensex_start, :sensex_end
    end
  end

  def self.down
    change_table :portfolios do |t|
      t.remove :sensex_start, :sensex_end
    end
  end
end
