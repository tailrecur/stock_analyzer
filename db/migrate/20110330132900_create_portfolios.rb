class CreatePortfolios < ActiveRecord::Migration
  def self.up
    create_table :portfolios do |t|
      t.string :name
      t.date :start_date
      t.timestamps
    end
  end

  def self.down
    drop_table :portfolios
  end
end
