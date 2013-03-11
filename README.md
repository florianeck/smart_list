# FRIENDS-Smart-List
SmartList Plug-In - Part of FRIENDS SmartConcepts
(c) 2011 Florian Eck, FRIENDS Financial Coaching

## About

This is my SmartList plugin, kinda raw, not yet test-covered or anything, but works good as hell.
Its kinda similar to acts_as_list, but it does the following things (better in my opinion, thats why i wrote it;-):

## Example:

    Class UserStuff < ActiveRecord::Base
        
      smart_list :group => :user_id, :base_class => 'UserStuff' # => shiity thing which needs to be fixed - always must pass the model name !
      # default value for ordering stuff is 'order_bit', could be anything else, like 'created_at' or what ever
      # u can ignore ':group' if u just want a whole table as one list
        
    end 

You have the following data in your user stuff table:

id    user_id   some_data     order_bit
1     1         'bli'         100
2     2         'bla'         100
3     3         'blubb'       100
4     1         'blibla'      101
5     1         'blubbblubb'  102
6     1         'abc'         103
7     2         'blubbbla'    101
8     3         'def'         101


Now u can do:

    stuff = UserStuff.find_by_user_id(1) # stuff is <UserStuff #1>

### Get all items in group
    stuff.group_list_items #=> returns [<UserStuff #1>, <UserStuff #4>, <UserStuff #5>, <UserStuff #6>]

### Or u do
    UserStuff.grouped_list(1) # Get all items with user_id 1

### if u have an item of a list, you can do:

    item.move_up!     # Move item up in oder position
    item.move_down!   # Move item down in oder position

    item.pre          # Get previous item in list, returns self when no other item is available
    item.post         # Get next item in list, returns self when no other item is available

    item.followers    # check which items are next in list
    item.group_list_items # show all items in group


### Includes Helpers, Partials and Controllers to do:


    <%= smart_list_links(item, options = {:uplink => {:text => "<", :class => nil}, :downlink => {:text => ">", :class => nil}}) %>
will render a button box for controlling the list items (movin up and down)

## Notes
No test coverage yet, hope u like it anyway





