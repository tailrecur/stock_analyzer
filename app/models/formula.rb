class Formula < ActiveRecord::Base
  def apply_to(company)
    sector = company.sector
    eval(value)
  end
end
