# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Formula.destroy_all

#Leverage Ratios
Formula.create!(:value => "company.debt_to_equity_ratio < company.sector.debt_to_equity_ratio") #1499
Formula.create!(:value => "company.debt_to_equity_ratio < 30")                    #828
Formula.create!(:value => "company.balance_sheet.debt_to_capital_ratio > 80", :weight => -1)
Formula.create!(:value => "company.balance_sheet.debt_ratio < 20", :weight => 2)

#Liquidity Ratios
Formula.create!(:value => "company.balance_sheet.acid_test_ratio < 1", :weight => -2)
Formula.create!(:value => "company.balance_sheet.net_cash < 0", :weight => -1)

#Profitability Ratios
Formula.create!(:value => "company.pe_ratio < company.sector.pe_ratio")           #1218
Formula.create!(:value => "company.peg_ratio < company.sector.peg_ratio")         #650
Formula.create!(:value => "company.roe > company.sector.roe")                     #1146
Formula.create!(:value => "company.roce > company.sector.roce")                   #965
Formula.create!(:value => "company.peg_ratio > 1", :weight => -2)   #296
#Formula.create!(:value => "(company.profit_growth_rate / company.pe_ratio) > 4", :weight => 2)

#Business Ratios
Formula.create!(:value => "company.price_to_book_value < company.sector.price_to_book_value") #1309
Formula.create!(:value => "company.ev_to_sales < company.sector.ev_to_sales")     #1279
Formula.create!(:value => "company.ev_to_ebitda < company.sector.ev_to_ebitda")   #1097

#Efficiency Ratios
Formula.create!(:value => "company.operating_cash_to_sales > company.sector.operating_cash_to_sales") #966
Formula.create!(:value => "company.expense_growth_rate > company.sales_growth_rate", :weight => -1)

#Formula.create!(:value => "company.balance_sheet.total_debt == 0", :weight => 2)
#Formula.create!(:value => "company.price * 0.67 <= company.balance_sheet.ncavps", :weight => 2)

#Formula.create!(:value => "company.price_to_intrinsic_value <= 1", :weight => 5)
#Formula.create!(:value => "company.price_to_intrinsic_value > 1 and company.price_to_intrinsic_value <= 5", :weight => 1)
#Formula.create!(:value => "company.price_to_intrinsic_value > 20", :weight => -5)


