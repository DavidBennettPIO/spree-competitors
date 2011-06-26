Deface::Override.new(:virtual_path => "layouts/admin",
                     :name => "admin_tab_competitors",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:competitors) %>",
                     :disabled => false)