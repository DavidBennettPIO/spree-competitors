module CompetitorPricesHelper
  
  def search_for_title title, link
    return link.content.downcase.gsub(/([^a-z0-9])/, '') == title
  end
  
end