module Admin::CompetitorPricesHelper
  
  def display_competitor_price our_price, competitor_price
    
    return '' if competitor_price.nil?
    
    if !competitor_price.price.nil?  && competitor_price.special_price.nil?
      price_string = color_price(our_price, competitor_price.price)
    end
    
    if !competitor_price.special_price.nil?  && competitor_price.special_price.nil?
      price_string = color_price(our_price, competitor_price.special_price)
    end
    
    if !competitor_price.price.nil?  && !competitor_price.special_price.nil?
      price_string = content_tag('span', number_to_currency(competitor_price.price), :style => 'text-decoration: line-through;') + ' ' +
            color_price(our_price, competitor_price.special_price)
    end

    price_string
  end
  
  def color_price our_price, competitor_price
    return '' if competitor_price == 0.0
    content_tag('span', 
      number_to_currency(competitor_price), 
      :style => 'color:' + ((competitor_price < our_price) ? 'red' : 'green'))
    
  end
  
  def display_variant_name variant
    variant.name
  end
  
end