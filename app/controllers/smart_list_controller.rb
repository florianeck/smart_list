# -*- encoding : utf-8 -*-
class SmartListController < ApplicationController
  ApplicationController.before_filters.each do |meth|
    skip_before_filter meth
  end
  
  def move_up
    item = params[:type].constantize.find(params[:id])
    item.move_up!
    redirect_to :back
  end

  def move_down
    item = params[:type].constantize.find(params[:id])
    item.move_down!
    redirect_to :back
  end
end
