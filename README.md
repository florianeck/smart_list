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

<table>
  <thead>
    <th>
      <td>id</td>
      <td>user_id</td>
      <td>some_date</td>
      <td>order_bit</td>
    </th>
  </thead>
  <tr><td>1</td><td>1</td><td>'bli'       </td><td>  100</td></tr>
  <tr><td>2</td><td>2</td><td>'bla'       </td><td>  100</td></tr>
  <tr><td>3</td><td>3</td><td>'blubb'     </td><td>  100</td></tr>
  <tr><td>4</td><td>1</td><td>'blibla'    </td><td>  101</td></tr>
  <tr><td>5</td><td>1</td><td>'blubbblubb'</td><td>  102</td></tr>
  <tr><td>6</td><td>1</td><td>'abc'       </td><td>  103</td></tr>
  <tr><td>7</td><td>2</td><td>'blubbbla'  </td><td>  101</td></tr>
  <tr><td>8</td><td>3</td><td>'def'       </td><td>  101</td></tr>
  
</table>

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

will render a button box for controlling the list items (movin up and down).
You can add custom text and/or css classes for up- and down-links (By default it displays &uarr; and &darr;)

## Notes
No test coverage yet, hope u like it anyway


## License

Copyright (c) 2013 Florian Eck

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.





