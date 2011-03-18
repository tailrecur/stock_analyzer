class QuarterlyResultsController < InheritedResources::Base
  respond_to :json

  belongs_to :company

#  def collection
#    @quarterly_results ||= end_of_association_chain.order("period_ended DESC").paginate(:page => params[:per_page])
#  end
end
