require 'nokogiri'
require 'open-uri'
require 'csv'

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

  desc "Update company data"
  task :update_data => :environment do
    url = "http://indiaearnings.moneycontrol.com/sub_india/comp_results.php?sc_did=mc_code"
    Company.where(:price => nil).find_each do |company|
      doc = Nokogiri::HTML(open(url_for(company, url)))
      company.price = doc.at_css("#nseprice b").text.strip
      fill_data(company, [:bse_code, :nse_code, :isin], doc.at_css(".MB10").text.strip.chomp(")").split("|").collect { |val| val.split(":").last.strip })
      fill_data(company, [:day_high, :day_low, :volume, :year_high, :year_low], doc.css("#nsetab .company td:last-child").map(&:text))
      fill_data(company, [:market_cap, :dividend_percentage, :eps_ttm, :pe_ratio, :book_value, :face_value], doc.css("div.PL15.PR15 table td:last-child").map(&:text))
      company.save!
      print "."
    end
  end

  desc "Update company prices from NSE"
  task :update_price_data => :environment do
    day = last_working_day(Date.yesterday)
    url = "http://www.nseindia.com/content/historical/EQUITIES/#{day.strftime("%Y/%b").upcase}/cm#{day.strftime("%d%b%Y").upcase}bhav.csv.zip"
    `wget --header="User-Agent: Mozilla/5.0" #{url} --output-document=tmp/nse_data.csv.zip`
    ActiveRecord::Base.transaction do
      CSV.parse(`unzip -p tmp/nse_data.csv.zip`) do |row|
        company = Company.find_by_nse_code(row.first)
        if company
          fill_data(company, [:day_high, :day_low, :price, :volume], row[3..5]+[row[8]])
          company.save!
        end
        print "."
      end
    end
  end

  def last_working_day(date)
    date.cwday <=5 ? date : last_working_day(date.yesterday)
  end


  def fill_data(model, attrs, data)
    attrs.each_with_index { |attr, index| model.send("#{attr}=", data[index].strip) }
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

  desc "Update profit and loss statements"
  task :update_profit_and_loss => :environment do
    process_for(:profit_and_losses, "http://www.moneycontrol.com/financials/company_name/profit-loss/mc_code") do |company|
      ProfitAndLoss
    end
  end

  def process_for(model_type, url)
    relevant_companies(model_type).each do |company|
      ActiveRecord::Base.transaction do
        table = Nokogiri::HTML(open(url_for(company, url))).at_css(".table4:nth-of-type(4)")

        periods = parse_periods(table)
        (puts("No data found for #{company.name}") and next) if periods.blank?

        data = parse_data(table)
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
      puts "."
    end
  end

  def relevant_companies(model_type)
    Company.joins("LEFT OUTER JOIN #{model_type} ON #{model_type}.company_id = companies.id").group("companies.id").having("ifnull(max(#{model_type}.created_at), date('1983-01-01')) < date(?)", [3.months.ago])
  end

  def url_for(company, url)
    url.sub("company_name", company.name.gsub(' ', '').downcase).sub("mc_code", company.mc_code)
  end

  def parse_data(table)
    {}.tap do |data|
      table.css("tr[height='22px']").each do |row|
        columns = row.css("td")
        data[columns.shift.text.strip] = columns.collect { |node| node.text.strip }
      end
    end
  end

  def parse_periods(table)
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