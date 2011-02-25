# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Formula.destroy_all
Formula.create!(:value => "company.pe_ratio < sector.pe_ratio")
Formula.create!(:value => "company.peg_ratio < sector.peg_ratio")
Formula.create!(:value => "company.ev_to_sales < sector.ev_to_sales")
Formula.create!(:value => "company.ev_to_ebitda < sector.ev_to_ebitda")
Formula.create!(:value => "company.roe > sector.roe")
Formula.create!(:value => "company.roce > sector.roce")
Formula.create!(:value => "company.debt_to_equity_ratio < sector.debt_to_equity_ratio")
Formula.create!(:value => "company.price_to_book_value < sector.price_to_book_value")

Formula.create!(:value => "company.sales_growth_rate > company.expense_growth_rate")
Formula.create!(:value => "company.balance_sheet.debt_to_capital_ratio < 20")
Formula.create!(:value => "company.price * 0.67 <= company.balance_sheet.ncavps")
Formula.create!(:value => "company.balance_sheet.net_cash > 0")
Formula.create!(:value => "company.peg_ratio < 1")
Formula.create!(:value => "(company.profit_growth_rate / company.pe_ratio) > 2")

Formula.create!(:value => "company.balance_sheet.debt_to_capital_ratio > 80", :weight => -1)
Formula.create!(:value => "company.balance_sheet.debt_ratio > 50", :weight => -1)
Formula.create!(:value => "company.balance_sheet.acid_test_ratio < 1", :weight => -1)
Formula.create!(:value => "(company.profit_growth_rate / company.pe_ratio) < 1", :weight => -1)