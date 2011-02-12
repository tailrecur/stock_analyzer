namespace :sector do
  
  desc "Retrieve list of sectors"
  task :retrieve_list => :environment do
    url = "http://www.moneycontrol.com/stocks/marketinfo/netprofit.php?indcode=Aluminium&optex=BSE"
    doc = Nokogiri::HTML(open(url))
    sectors = doc.css("#sel_code option").map(&:text)
    sectors.shift #Remove the dummy 'Sector' on top
    puts "Retrieved #{sectors.size} sectors"
    sectors.each  {|sector| Sector.find_or_create_by_name(sector)}
  end
end