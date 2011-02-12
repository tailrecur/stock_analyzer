require 'nokogiri'
require 'open-uri'

namespace :company do

  desc "Retrieve latest list of companies and populate database"
  task :retrieve_latest => :environment do
    url = "http://www.moneycontrol.com/portfolio_plus/search_result_div.php"
    doc = Nokogiri::HTML(open(url))
    companies = doc.css("option")
    puts "Retrieved #{companies.size} companies"
    companies.each do |company|
      combined_code = company[:value].split('|')
      unless Company.find_by_mc_code(combined_code.second)
        puts "Creating company #{combined_code.first}"
        Company.create!(:name => combined_code.first, :mc_code => combined_code.second)
      end
    end
  end

  desc "Update balance_sheets"
  task :update_balance_sheets => :environment do
    url = "http://www.moneycontrol.com/financials/company_name/balance-sheet/mc_code"
    Company.find_each do |company|
      doc = Nokogiri::HTML(open(url.sub("company_name", company.name.gsub(' ', '').underscore).sub("mc_code", company.mc_code)))
      table = doc.at_css(".table4:nth-of-type(4)")
      periods = table.css("tr:nth-child(1) .detb[align='right']").collect { |node| node.text.strip }
      data = parse_data(table)

      balance_sheet_class = company.name.downcase.include?('bank') ? BankBalanceSheet : CompanyBalanceSheet
      periods.each_with_index do |period, index|
        balance_sheet = company.balance_sheets.where(:period_ended => Date.parse(period)).first
        if balance_sheet
          populate_model(balance_sheet, data, index)
          if balance_sheet.changed?
            puts "Updating balance sheet for #{company.name} for year ended #{period}"
            balance_sheet.save!
          end
        else
          puts "Creating balance sheet for #{company.name} for year ended #{period}"
          company.balance_sheets << populate_model(balance_sheet_class.new(:period_ended => Date.parse(period)), data, index)
        end
      end
    end
  end

  def parse_data(table)
    {}.tap do |data|
      table.css("tr[height='22px']")[3..-1].each do |row|
        columns = row.css("td")
        data[columns.shift.text.strip] = columns.collect { |node| node.text.strip }
      end
    end
  end

  def populate_model(model, data, index)
    data.each do |attr, values|
      attribute = translated_attribute(attr)
      model.send("#{attribute}=", values[index]) if model.respond_to?(attribute)
    end
    model
  end

  def translated_attribute(attribute)
    non_standard_attributes[attribute] || attribute.gsub(" ", '').underscore
  end

  def non_standard_attributes
    @non_standard_attributes ||= YAML::load_file("config/non_standard_attributes.yml")
  end
end