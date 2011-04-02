require 'has_scope'

class StockTransactionsController < InheritedResources::Base
  before_filter lambda { @portfolio = Portfolio.find(params[:portfolio_id]) }

  has_scope :company, :as => :company_id

  def create
    portfolio_stock = PortfolioStock.find_or_create_by_portfolio_id_and_company_id(@portfolio, params.delete(:company_id))
    @stock_transaction = StockTransaction.create(params[:stock_transaction].merge(:portfolio_stock => portfolio_stock))
    if @stock_transaction.save
      redirect_to portfolio_url(@portfolio)
    else
      render :action => :new
    end
  end

  def new
    @stock_transaction = StockTransaction.new
  end

  def update
    update! { portfolio_stock_transaction_path(@portfolio) }
  end

  def destroy
    destroy! { portfolio_stock_transactions_path(@portfolio) }
  end
end
