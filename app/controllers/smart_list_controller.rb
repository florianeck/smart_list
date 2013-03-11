# -*- encoding : utf-8 -*-
class SmartListController < ApplicationController
  
  before_filter :check_smart_list
  
  def move_up
    begin
      @item.move_up!
      flash[:notice] = "Item moved up"
    rescue
      flash[:error] = "Item could not be moved"
    end
    redirect_to :back
  end

  def move_down
    begin
      @item.move_down!
      flash[:notice] = "Item moved down"
    rescue
      flash[:error] = "Item could not be moved"
    end
    redirect_to :back
  end
  
  
  private
  
  # Verify data
  def check_smart_list
    params[:type] = $active_smart_lists[params[:type]]
    if params[:type].blank? || params[:id].blank?
      flash[:error] = "You need to specify a :type and an :id"
      redirect_to :back
    elsif !(params[:type].constantize.is_smart_list? rescue false )
      flash[:error] = "#{params[:type]} is not a smart_list item"
      redirect_to :back
    else 
      @item = params[:type].constantize.find(params[:id]) rescue nil
      if @item.nil?
        flash[:error] = "Item not found"
      else  
        return true
      end  
    end  
          
      
  end  
  
end
