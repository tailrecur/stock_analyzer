class PortfoliosController < InheritedResources::Base
  def create
    create! { portfolios_url }
  end
end
