class DropColumnsFromCompany < ActiveRecord::Migration
  def self.up
    change_table :companies do |t|
      t.remove :eps_ttm, :pe_ratio, :market_cap, :book_value, :face_value, :dividend_percentage
      t.boolean :active, :default => true
    end
  end

  def self.down
    change_table :companies do |t|
      t.float :eps_ttm, :pe_ratio, :market_cap, :book_value, :face_value, :dividend_percentage
      t.remove :active
    end
  end
end
