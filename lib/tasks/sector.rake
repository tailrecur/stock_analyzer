namespace :sector do
  
  desc "Retrieve latest list of sectors"
  task :retrieve_latest => :environment do
    url = "http://www.moneycontrol.com/stocks/marketinfo/netprofit.php?indcode=Aluminium&optex=BSE"
    doc = Nokogiri::HTML(open(url))
    sectors = doc.css("#sel_code option").map(&:text)
    sectors.shift #Remove the dummy 'Sector' on top
    puts "Retrieved #{sectors.size} sectors"
    sectors.each  {|sector| Sector.find_or_create_by_name(sector)}
  end
  
  desc "Retrieve companies by sector"
  task :populate_by_sector => :environment do
    url = "http://www.moneycontrol.com/stocks/marketinfo/marketcap.php?indcode=sector_name&optex=BSE"
    count = 0
    Sector.all.each do |sector|
      doc = Nokogiri::HTML(open(url.sub("sector_name", CGI::escape(sector.name))))  
      puts "Did not find data for sector #{sector.name}" if doc.css("td a").blank?
      doc.css("td a").each do |anchor|
        mc_code = anchor[:href].split('/').last
        company = Company.where(:mc_code => mc_code).includes(:sector).first
        count = count + 1
        if company
          puts "Found company #{company.name} with sector #{company.sector.name}"
          if company.sector != sector
            puts "Updating #{company.name} with sector #{sector.name}"
            company.update_attributes(:sector => sector)
          end
        else
          puts "Did not find company with code #{mc_code}"
          doc = Nokogiri::HTML(open("http://www.moneycontrol.com" + anchor[:href]))  
          company_name = doc.at_css("h1").text.strip
          puts "Creating company with name #{company_name}, mc_code #{mc_code} for sector #{sector.name}"
          Company.create!(:name => company_name, :mc_code => mc_code, :sector => sector)
        end
      end
    end
    puts "\nProcessed #{count} companies"
  end

  desc "Retrieve companies by sector"
  task :populate_by_company => :environment do
    url = "http://indiaearnings.moneycontrol.com/sub_india/comp_results.php?sc_did=mc_code"
    Company.where(:sector_id => nil).each do |company|
      doc = Nokogiri::HTML(open(url.sub("mc_code", company.mc_code)))  
      sector_name = doc.at_css('.PT5:nth-child(1) strong').text.strip
      if sector_name.blank?
        puts "Did not find sector for company #{company.name}"
      else
        sector = Sector.find_by_name(sector_name)
        if sector
          company.update_attributes(:sector => sector)
        else
          puts "Did not find sector by name - #{sector_name}"
        end
      end
    end
  end
end