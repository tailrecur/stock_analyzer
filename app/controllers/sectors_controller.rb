class SectorsController < InheritedResources::Base
  protected

  def collection
    @sectors = end_of_association_chain.all.sort
  end
end
