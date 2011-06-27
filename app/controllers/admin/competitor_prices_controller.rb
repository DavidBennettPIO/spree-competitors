require 'nokogiri'
require 'open-uri'
class Admin::CompetitorPricesController < Admin::BaseController
  
  include ProductsHelper
  include Spree::BaseHelper
  
  helper :products
  
  def get_competitor_price variant, competitor

    search_page = eval('"' + competitor.search_page + '"')
    price = nil
    price_content = nil
    special_price_content = nil
    price_string = ''
    doc = Nokogiri::HTML(open(search_page))
    puts search_page
    if !competitor.search_link_selector.blank?

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
        
        doc = Nokogiri::HTML(open(product_page))

      end
    end

    title = variant.name.downcase.gsub(/([^a-z0-9])/, '')
    
    use_index = 0
    unless competitor.search_name_selector.blank?
      doc.css(competitor.search_name_selector).each_with_index do |link, i|
        puts i.to_s + ' ' + link.content.downcase.gsub(/([^a-z0-9])/, '')
        use_index = i if link.content.downcase.gsub(/([^a-z0-9])/, '') == title
      end
    end
    puts use_index
    unless competitor.search_price_selector.blank?
      doc.css(competitor.search_price_selector).each_with_index do |p,i|
        price_content = p if i == use_index
        puts i.to_s + ' == ' + use_index.to_s
        puts p.content if i == use_index
      end
      price_content = doc.css(competitor.search_price_selector).first if price_content.nil?
    end
    
    unless competitor.search_special_price_selector.blank?
      doc.css(competitor.search_special_price_selector).each_with_index do |p,i|
        special_price_content = p if i == use_index
      end
      special_price_content = doc.css(competitor.search_special_price_selector).first if special_price_content.nil?
    end

    cp = CompetitorPrice.new
    
    cp.price = price_content.content.gsub(/([^0-9\.])/, '').to_f unless price_content.nil?
    cp.special_price = special_price_content.content.gsub(/([^0-9\.])/, '').to_f unless special_price_content.nil?
    puts cp.price
    cp

  end
  
  def index
    
    @results = []
    @variants = []
    @variant_prices = []
    @competitors = []
    variant_i = 0
    competitor_i = 0
    
    Competitor.all.each do |competitor|
      @competitors[competitor_i] = competitor.name
      competitor_i = competitor_i + 1
    end

    Variant.joins(:product).where('products.deleted_at IS NULL AND variants.deleted_at IS NULL').includes(:product).order('products.available_on DESC').limit(300).all.each do |variant|
      @variants[variant_i] = variant
      @results[variant_i] = []
      competitor_i = 0
      Competitor.all.each do |competitor|
        #  get_competitor_price variant, competitor
        @results[variant_i][competitor_i] = CompetitorPrice.where(:competitor_id => competitor.id, :variant_id => variant.id).first
        competitor_i = competitor_i + 1
      end
      variant_i = variant_i +1
    end
  end
end
