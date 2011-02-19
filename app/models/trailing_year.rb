class TrailingYear
  extend ActiveSupport::Memoizable

  def initialize(company)
    @company = company
    @quarterly_results = []
  end

  attr_reader :quarterly_results, :company

  def eps
    quarters.collect(&:eps).sum
  end

  def sales
    quarters.collect(&:sales_turnover).sum
  end

  def ebitda
    quarters.collect(&:operating_profit).sum
  end

  def depreciation
    quarters.collect(&:depreciation).sum
  end

  def other_income
    quarters.collect(&:other_income).sum
  end

  def net_profit
    quarters.collect(&:net_profit).sum
  end

  def quarters
    QuarterlyResult.where(:company_id => company.id).yearly_latest
  end
  memoize :quarters
end