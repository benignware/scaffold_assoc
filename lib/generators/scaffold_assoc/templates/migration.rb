class Create<%= table_name.classify.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t| 
<% attributes.each do |a| %>
      t.<%= a.type %> :<%= a.name %>
<% end %>
      t.integer :<%= parent_singular_table_name %>_id
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end