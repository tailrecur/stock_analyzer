require 'has_scope'

class CompaniesController < InheritedResources::Base
  respond_to :json

  has_scope :name_like

  def index
    @companies ||= end_of_association_chain.includes(:sector).order("score DESC, sector_id").paginate(:page => params[:page])
    index!
  end
end
