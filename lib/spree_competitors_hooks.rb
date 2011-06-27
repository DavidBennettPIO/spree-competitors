Deface::Override.new(:virtual_path => "admin/configurations/index",
                     :name => "admin_configuration_competitors",
                     :insert_bottom => "[data-hook='admin_configurations_menu']",
                     :text => "<tr><td><%= link_to t(:competitors), admin_competitors_path %></td><td></td></tr>",
                     :disabled => false)
                     
Deface::Override.new(:virtual_path => "layouts/admin",
                     :name => "admin_tab_competitor_prices",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:competitor_prices) %>",
                     :disabled => false)