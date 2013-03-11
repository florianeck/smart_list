# -*- encoding : utf-8 -*-

require "smart_list"
require "add_order_bit"


module SmartList
  
  def self.included(base)
    base.extend ClassMethods
  end  
  
  module ClassMethods
    def smart_list(options = {:order_bit => "order_bit", :group => nil, :scope_conditions => nil})
      # Check if order_bit exists
      options[:order_bit] ||= "order_bit"
      options[:fixed] ||= false
      if self.column_names.index(options[:order_bit].to_s).nil?
        ::AddOrderBit.add_to_table(self.table_name)
      else
        unless is_smart_list?
          cattr_accessor :group_col, :order_bit_name, :base_class, :fixed_list
          send :include, InstanceMethods
        end  
        self.send(:default_scope, :order => "#{options[:order_bit].to_s} ASC")
        self.send(:before_create, :set_order_bit)
        self.group_col = (options[:group].to_sym) rescue nil
        self.order_bit_name = options[:order_bit].to_sym
        self.base_class = options[:base_class].constantize rescue self.name.constantize
        self.fixed_list = options[:fixed]
      end
    end
    
    def grouped_list(group_name)
      if self.group_col.nil? || self.group_col.blank?
        self.find(:all)
      else
        self.find(:all, :conditions => {self.group_col => group_name})
      end  
    end
    
    def groups
      if self.group_col.nil? || self.group_col.blank?
        raise "This is not a grouped list - use options[:group] set colummn to group lists"
      else
        puts self.group_col.inspect
        self.find(:all, :group => self.group_col).map {|x| x.group_name }
      end
    end
    
    def group_list
      self.groups.map {|group| self.find(:all, :conditions => {self.group_col => group})}
    end    
    
    def is_smart_list?
      self.included_modules.include?(InstanceMethods)
    end
    
    def reorder_group(group_name, options = {:order_by => :created_at})
      if self.group_col.nil? || self.group_col.blank?
        raise "Only grouped lists could be reordered"
      else
        transaction do
          group = self.grouped_list(group_name)
          order_mode = options[:order_by].to_s
          ordered = group.sort_by {|item| item.send(order_mode)}
          ordered.each_with_index do |item, i| 
            item[self.base_class.order_bit_name] = AddOrderBit::ORDER_BIT_DEFAULT+i
            item.send(:update_without_callbacks)
          end  
          
          new_group = self.grouped_list(group_name).map {|item| item.id}
          if new_group == ordered.map {|item| item.id}
            return true
          else
            raise ActiveRecord::Rollback
            return false
          end  
        end  
      end    
    end     
  end  
  
  module InstanceMethods
    def move_up!
      if self.base_class.fixed_list == false
        unless self.order_position == 0
          old_pos = self.order_bit_pos
          pre_item = self.pre
          if old_pos != pre_item.order_bit_pos
            self.update_attributes(self.base_class.order_bit_name => pre_item.order_bit_pos)
            pre_item.update_attributes(self.base_class.order_bit_name => old_pos)
          else
            self.update_attributes(self.base_class.order_bit_name => old_pos-1)
          end    
        end
      end  
    end
    
    def move_down!
      if self.base_class.fixed_list == false
        if self.base_class.group_col.nil?     
          all = self.base_class.find(:all)
        else
          all = self.base_class.find(:all, :conditions => {self.base_class.group_col => self.send(self.base_class.group_col)})
        end
        unless self.order_position == all.size-1
           old_pos = self.order_bit_pos
           post_item = self.post
           if old_pos != post_item.order_bit_pos
             self.update_attributes(self.base_class.order_bit_name => post_item.order_bit_pos)
             post_item.update_attributes(self.base_class.order_bit_name => old_pos)
           else 
             self.update_attributes(self.base_class.order_bit_name => old_pos+1)
            end 
        end
      end  
    end
    
    def group_list_items(conditions = {})
      if self.base_class.group_col.nil? || self.base_class.group_col.blank?
        self.base_class.find(:all)
      else
        self.base_class.find_by_sql("SELECT * from #{self.base_class.table_name} where #{self.base_class.group_col} = '#{self[self.base_class.group_col].to_s}' order by #{self.base_class.order_bit_name} ASC")
      end
    end  
    
    # Previos Item
    def pre
      pos = (self.order_position == 0 ? 0 : (self.order_position - 1 rescue 0))
      all = self.group_list_items[pos]
    end
    
    # Next Item
    def post
      all = self.group_list_items
      pos = (self.order_position == all.size-1 ? self.order_position : self.order_position + 1)
      all[pos]
    end
    
    def order_position
      all = self.group_list_items.map {|x| x.id}  
      all.index(self.id)
    end
    
    def order_bit_pos
      self.attributes[self.base_class.order_bit_name.to_s]
    end
    
    def group_name
      if self.base_class.group_col.nil?     
        ""
      else
        self.send(self.base_class.group_col.to_s)
      end
    end    
    
    def set_order_bit
      if self.base_class.fixed_list == false
        self[self.base_class.order_bit_name] = self.base_class.last[self.base_class.order_bit_name] + 1 rescue 100
      end  
    end
    
    def followers(options = {})
      if self.base_class.group_col.nil? 
        self.base_class.find_by_sql("SELECT * from #{self.base_class.table_name} where #{self.base_class.order_bit_name} #{options[:include_self] == true ? '>=' : '>'} #{self.order_bit}")    
      else
        self.base_class.find_by_sql("SELECT * from #{self.base_class.table_name} where #{self.base_class.order_bit_name} #{options[:include_self] == true ? '>=' : '>'} #{self.order_bit} and #{self.base_class.group_col.to_s} = '#{self.group_name}'")    
      end    
    end  
    
    def previous_items(options = {})
      if self.base_class.group_col.nil? 
        self.base_class.find_by_sql("SELECT * from #{self.base_class.table_name} where #{self.base_class.order_bit_name} #{options[:include_self] == true ? '<=' : '<'} #{self.order_bit}")    
      else
        self.base_class.find_by_sql("SELECT * from #{self.base_class.table_name} where #{self.base_class.order_bit_name} #{options[:include_self] == true ? '<=' : '<'} #{self.order_bit} and #{self.base_class.group_col.to_s} = '#{self.group_name}'")    
      end    
    end
  end    
        

end  

ActiveRecord::Base.send(:include, SmartList)
ActionController::Base.helper SmartListHelper

