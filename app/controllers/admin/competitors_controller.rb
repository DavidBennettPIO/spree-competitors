class Admin::CompetitorsController < Admin::ResourceController
  
  respond_override :update => { :html => { :success => lambda { redirect_to collection_url } } }
  respond_override :create => { :html => { :success => lambda { redirect_to collection_url } } }
  respond_override :destroy => { :js => { :success => lambda { render_js_for_destroy } } }
end
