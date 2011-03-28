class StockTransactionsController < InheritedResources::Base
  def create
    params[:stock_transaction].delete(:company)
    create!
  end
end
