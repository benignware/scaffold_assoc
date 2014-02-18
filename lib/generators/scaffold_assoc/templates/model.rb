class <%= class_name %> < ActiveRecord::Base
  belongs_to :<%= parent_singular_table_name %>
end
