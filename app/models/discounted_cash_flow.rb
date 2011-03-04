class DiscountedCashFlow
  def initialize(company)
    @company = company
  end

  attr_reader :company

  def fcf_average
#    fcfs = []
#    cash_flows_for_dcf.each_with_index { |cash_flow, index| fcfs << (cash_flow.free_cash - profit_and_losses_for_growth[index].equity_dividend) }
#    fcfs.average * ((1.06) ** 3) #Assuming 6% average inflation for India
    profit_and_loss.net_profit + balance_sheet.accumulated_depreciation + cash_flow.cash_from_investment - balance_sheet.total_debt
  end

  def discount_rate
    0.12
  end

  def growth_rate
    [profit_growth_rate, 30.0].min
  end

  def fcfs
    future_fcf = fcf_average
    [].tap do |fcfs|
      (1..5).each { |n|
        future_fcf = future_fcf * (1 + growth_rate/100)
        fcfs <<  (future_fcf / (1 + discount_rate) ** n)
      }
      (6..10).each { |n|
        future_fcf = future_fcf * (1 + (growth_rate/2)/100)
        fcfs <<  (future_fcf / (1 + discount_rate) ** n)
      }
    end
  end

  def intrinsic_value
    discounted_value + perpetuity_value
  end

  def price_to_intrinsic_value
    price.divide_by(intrinsic_value.divide_by(issued_shares))
  end

  def discounted_value
    if total_common_equity > 0
      fcfs.sum + 0.8 * total_common_equity
    else
      fcfs.sum + total_common_equity / 0.8
    end
  end

  def perpetuity_value
    future_last_fcf = fcfs.last * ((1 + discount_rate) ** 10)
    (future_last_fcf * 1.05 / (discount_rate - 0.05)) / ((1 + discount_rate) ** 10) #Assuming 5% perpetuity growth rate
  end
end