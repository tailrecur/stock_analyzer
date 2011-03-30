class StockTransactionsController < InheritedResources::Base
  def create
    params[:stock_transaction].delete(:company)
    create! { stock_transactions_url }
  end
end
