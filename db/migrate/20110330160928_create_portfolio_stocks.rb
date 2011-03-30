class CreatePortfolioStocks < ActiveRecord::Migration
  def self.up
    create_table :portfolio_stocks do |t|
      t.references :portfolio
      t.references :company
      t.timestamps
    end
    change_table :stock_transactions do |t|
      t.references :portfolio_stock
    end
  end

  def self.down
    drop_table :portfolio_stocks
    change_table :stock_transactions do |t|
      t.remove :portfolio_stock_id
    end
  end
end
