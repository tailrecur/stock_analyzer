class CompaniesController < InheritedResources::Base
  protected
  def collection
    @companies ||= end_of_association_chain.includes(:sector).paginate(:page => params[:page])
  end
end
