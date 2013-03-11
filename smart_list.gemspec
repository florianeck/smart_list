Gem::Specification.new do |s|
  s.name        = 'smart_list'
  s.version     = '0.0.2'
  s.date        = '2013-03-11'
  s.summary     = "List-style behavior for ActiveRecordt "
  s.description = "Easy to use list behavior for ActiveRecord models, includes grouping of items by column content, order, reorder and helpers for ActionView"
  s.authors     = ["Florian Eck"]
  s.email       = 'it-support@friends-systems.de'
  s.files       = ["lib/smart_list.rb", "lib/add_order_bit.rb", "lib/smart_list_helper.rb"]
  s.files       << %w(app/controllers/smart_list_controller.rb app/views/smart_links/_move_links.html.erb)
  s.files       << %w(README.md)
  s.files       = s.files.flatten
  s.homepage    = "https://github.com/florianeck/smart_list"
end