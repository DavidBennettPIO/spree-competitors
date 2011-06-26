require 'nokogiri'
require 'open-uri'
class Admin::CompetitorPricesController < Admin::BaseController
  
  include ProductsHelper
  
  def index
    
    @results = []
    @variants = []
    @variant_prices = []
    @competitors = []
    variant_i = 0
    
    Variant.joins(:product).where('products.available_on > ?', 1.week.ago).all.each do |variant|
      
      @variants[variant_i] = variant
      @results[variant_i] = []
      competitor_i = 0
      Competitor.all.each do |competitor|
        
        puts competitor.name
        search_page = eval('"' + competitor.search_page + '"')
        puts search_page
        price = nil
        special_price = nil
        price_string = ''
        doc = Nokogiri::HTML(open(search_page))
        
        if !competitor.search_link_selector.blank?
        
          puts competitor.search_link_selector
          link = doc.css(competitor.search_link_selector).first
          if !link.nil?
            product_page = link['href']
            
            if product_page[0] == '/'
              uri = URI.parse(search_page)
              product_page = uri.scheme + '://' + uri.host + product_page
            end
            if product_page[0..3] != 'http'
              uri = URI.parse(search_page)
              product_page = uri.scheme + '://' + uri.host + '/' + product_page
            end
            puts product_page
            
            doc = Nokogiri::HTML(open(product_page))

          end
        end
        
        price_content = doc.css(competitor.search_price_selector).first.content unless competitor.search_price_selector.blank?
        special_price_content = doc.css(competitor.search_special_price_selector).first.content unless competitor.search_special_price_selector.blank?
        
        price = price_content.gsub(/([^0-9\.])/, '').to_f unless price_content.nil?
        special_price = special_price_content.gsub(/([^0-9\.])/, '').to_f unless special_price_content.nil?
        
        
        price_string = format_price(price) if !price.nil?  && special_price.nil?
        price_string = format_price(special_price) if price.nil?  && !special_price.nil?
        price_string = content_tag('span', format_price(price)) + content_tag('span', format_price(special_price)) if !price.nil?  && !special_price.nil?
        
        
        puts price_string
        @competitors[competitor_i] = competitor.name
        @results[variant_i][competitor_i] = price_string
        
        competitor_i = competitor_i + 1
      end
      variant_i = variant_i +1
    end
  end

end