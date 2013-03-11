# -*- encoding : utf-8 -*-
class AddOrderBit < ActiveRecord::Migration
 
  ORDER_BIT_DEFAULT = 100
 
  def self.add_to_table(table_name)
    add_column table_name, :order_bit, :integer, :default => ORDER_BIT_DEFAULT
  end  
  
end  
