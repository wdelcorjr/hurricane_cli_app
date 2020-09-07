require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
site = "https://www.wunderground.com/hurricane" 

def self.scrape_regions_and_activity
    doc = Nokogiri::HTML(open(site))
    region_activity_hash = {}
    regions = doc.css('.ng-star-inserted').css('.basin-row').children.map {|e| e.css('span').text}.reject{|e| e == ""} 
    region_activity_hash[:atlantic_ocean] = regions[0]
    region_activity_hash[:eastern_pacific] = regions[1]
    region_activity_hash[:western_pacific] = regions[2]
    region_activity_hash[:central_pacific] = regions[3]
    region_activity_hash[:southern_hemisphere] = regions[4]
    region_activity_hash[:indian_ocean] = regions[5]
    region_activity_hash_hash = region_activity_hash.map {|key, value| {region: key.to_s.gsub("_", " ").upcase, active_storms: value}}
end

def self.scrape_storms_and_details
    storm_names = doc.css('.ng-star-inserted').css('.storm').children.map {|e| e.css('a').first.text}.reject{|e| e == ""} 
    storm_details = doc.css('.ng-star-inserted').css('.storm').children.map {|e| e.css('.storm-details').text}.reject{|e| e == ""} 
    storm_names_and_details = Hash[storm_names.zip(storm_details)]
end
# binding.pry
# puts storm_names
# puts storm_details
# puts region_activity_hash
current_storms = storm_names_and_details.map {|key, value| {name: key, details: value}}
puts region_activity_hash_hash
puts current_storms
end