class CreatePortfolios < ActiveRecord::Migration
  def self.up
    create_table :portfolios do |t|
      t.string :name
      t.date :start_date
      t.timestamps
    end
    change_table :stock_transactions do |t|
      t.references :portfolio
    end
  end

  def self.down
    drop_table :portfolios
    change_table :stock_transactions do |t|
      t.remove :portfolio_id
    end
  end
end
