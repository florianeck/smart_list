# -*- encoding : utf-8 -*-
module SmartListHelper
  
  def render_list(list)
    
  end  
  
  def smart_list_links(item, options = {:uplink => {:text => "&uarr;", :class => nil}, :downlink => {:text => "&darr;", :class => nil}})
    render :partial => "/smart_links/move_links", :locals => {:item => item, :options => options}
  end  
  
end  
