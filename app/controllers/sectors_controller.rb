class SectorsController < InheritedResources::Base
  protected

  def collection
    @sectors = end_of_association_chain.includes(:companies).all.sort
  end
end
