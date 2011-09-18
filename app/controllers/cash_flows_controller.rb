class CashFlowsController < InheritedResources::Base
  respond_to :json

  belongs_to :company

  def collection
    end_of_association_chain.order("period_ended desc").limit(params[:per_page]).reverse
  end
end
