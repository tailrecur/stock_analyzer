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
    process_for(:balance_sheets, "http://www.moneycontrol.com/financials/company_name/balance-sheet/mc_code") do |company|
      company.name.downcase.include?('bank') ? BankBalanceSheet : CompanyBalanceSheet
    end
  end

  desc "Update quarterly_results"
  task :update_quarterly_results => :environment do
    process_for(:quarterly_results, "http://www.moneycontrol.com/financials/company_name/results/quarterly-results/mc_code") do |company|
      QuarterlyResult
    end
  end

  def process_for(model_type, url)
    Company.all[0..3].each do |company|
      ActiveRecord::Base.transaction do
        doc = Nokogiri::HTML(open(url_for(company, url)))
        periods, data = parse_data(doc)
        next if periods.blank?
        periods.each_with_index do |period, index|
          model = company.send(model_type).where(:period_ended => period).first
          if model
            populate_model(model, data, index)
            if model.changed?
              puts "Updating #{model_type} for #{company.name} for year ended #{period}"
              model.save!
            end
          else
            puts "Creating #{model_type} for #{company.name} for year ended #{period}"
            model_class = yield(company)
            company.send(model_type) << populate_model(model_class.new(:period_ended => period), data, index)
          end
        end
      end
      print "."
    end
  end

  def url_for(company, url)
    url.sub("company_name", company.name.gsub(' ', '').downcase).sub("mc_code", company.mc_code)
  end

  def parse_data(doc)
    data = {}
    table = doc.at_css(".table4:nth-of-type(4)")
    periods = retrieve_periods(table)
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

  def retrieve_periods(table)
    table.css(".detb[align='right']").take_while { |node| Date.parse(node.text.strip) rescue nil }.collect { |node| Date.parse(node.text.strip) }
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