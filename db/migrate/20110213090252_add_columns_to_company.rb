class AddColumnsToCompany < ActiveRecord::Migration
  def self.up
    change_table :companies do |t|
      t.float :day_high, :day_low, :price, :year_high, :year_low, :volume
      t.float :market_cap, :dividend_percentage, :eps_ttm, :pe_ratio, :book_value, :face_value
      t.string :bse_code, :nse_code, :isin
    end
  end

  def self.down
    remove_column :companies, :high_price, :low_price, :closing_price, :year_high, :year_low, :volume
    remove_column :companies, :market_cap, :dividend_percentage, :eps_ttm, :pe_ratio, :book_value, :face_value
    remove_column :companies, :bse_code, :nse_code, :isin
  end
end
