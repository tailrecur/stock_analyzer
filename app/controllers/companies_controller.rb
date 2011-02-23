class CompaniesController < InheritedResources::Base

  def index
    @companies ||= end_of_association_chain.includes(:sector).order("score DESC, sector_id").paginate(:page => params[:page])
    index!
  end

  def show
    @formulae = Formula.all
    show!
  end
  protected
end
