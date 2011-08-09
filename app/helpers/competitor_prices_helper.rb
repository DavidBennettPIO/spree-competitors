module CompetitorPricesHelper
  
  def search_for_title variant, link
    title = variant.name.downcase.gsub(/([^a-z0-9])/, '')
    return link.content.downcase.gsub(/([^a-z0-9])/, '') == title
  end
  
end