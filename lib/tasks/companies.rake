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
      doc = Nokogiri::HTML(open(url.sub("company_name", company.name.gsub(' ', '').downcase).sub("mc_code", company.mc_code)))

      periods, data = parse_data(doc)
      next if periods.blank?

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

  desc "Update quarterly_results"
  task :update_quarterly_results => :environment do
    url = "http://www.moneycontrol.com/financials/company_name/results/quarterly-results/mc_code"
    Company.find_each do |company|
      ActiveRecord::Base.transaction do
        doc = Nokogiri::HTML(open(url.sub("company_name", company.name.gsub(' ', '').downcase).sub("mc_code", company.mc_code)))

        periods, data = parse_data(doc)
        next if periods.blank?

        periods.each_with_index do |period, index|
          quarterly_result = company.quarterly_results.where(:period_ended => Date.parse(period)).first
          if quarterly_result
            populate_model(quarterly_result, data, index)
            if quarterly_result.changed?
              puts "Updating quarterly result for #{company.name} for year ended #{period}"
              quarterly_result.save!
            end
          else
            puts "Creating quarterly result for #{company.name} for year ended #{period}"
            company.quarterly_results << populate_model(QuarterlyResult.new(:period_ended => Date.parse(period)), data, index)
          end
        end
      end
    end
  end

  def parse_data(doc)
    data = {}
    table = doc.at_css(".table4:nth-of-type(4)")
    periods = table.css("tr:nth-child(3) .detb[align='right']").collect { |node| node.text.strip }
    if periods.blank?
      puts("No data found for #{doc.at_css('.pg_head').text.strip}")
    else
      table.css("tr[height='22px']").each do |row|
        columns = row.css("td")
        data[columns.shift.text.strip] = columns.collect { |node| node.text.strip }
      end
    end
    [periods, data]
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