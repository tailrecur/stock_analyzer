class ProfitAndLossesController < InheritedResources::Base
  respond_to :json

  belongs_to :company

  def collection
    end_of_association_chain.order("period_ended").limit(params[:per_page])
  end
end
