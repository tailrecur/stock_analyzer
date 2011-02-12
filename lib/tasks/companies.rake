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
        sector = Sector.find_or_create_by_mc_code(combined_code.last)
        Company.create!(:name => combined_code.first, :mc_code => combined_code.second, :sector => sector)
      end
    end
  end
end