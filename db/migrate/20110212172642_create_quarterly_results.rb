class CreateQuarterlyResults < ActiveRecord::Migration
  def self.up
    create_table :quarterly_results do |t|
      t.date :period_ended

      t.float :sales_turnover, :other_income, :total_income, :total_expenses, :operating_profit
      t.float :profit_on_assets_sale, :profit_on_investments_sale, :profit_on_forex, :vrs_adjustment
      t.float :other_extraordinary_income, :total_extraordinary_income, :tax_on_extraordinary_income, :net_extraordinary_income
      t.float :gross_profit, :interest, :pbdt, :depreciation, :depreciation_on_revaluated_assets, :pbt, :tax
      t.float :net_profit, :prior_years_income, :depreciation_for_previous_years, :dividend, :dividend_tax, :dividend_percentage
      t.float :eps, :book_value, :equity, :reserves, :face_value

      t.references :company
      t.timestamps
    end
    add_index :quarterly_results, [:company_id, :period_ended], :unique => true
    add_column :companies, :quarterly_results_count, :integer, :default => 0
  end

  def self.down
    drop_table :quarterly_results
    remove_column :companies, :quarterly_results_count
  end
end
