<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= parent_singular_table_name %>, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = @<%= parent_singular_table_name %> ? <%= class_name %>.where(<%= parent_singular_table_name %>: @<%= parent_singular_table_name %>) : <%= orm_class.all(class_name) %>
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    @<%= singular_table_name %>.<%= parent_singular_table_name %> = @<%= parent_singular_table_name %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= singular_table_name %>.<%= parent_singular_table_name %> = @<%= parent_singular_table_name %>
    if @<%= orm_instance.save %>
      redirect_to <%= parent_singular_table_name %>_<%= singular_table_name %>_path(@<%= parent_singular_table_name %>, @<%= singular_table_name %>), notice: <%= "'#{human_name} was successfully created.'" %>
    else
      render action: 'new'
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to <%= parent_singular_table_name %>_<%= singular_table_name %>_path(@<%= parent_singular_table_name %>, @<%= singular_table_name %>), notice: <%= "'#{human_name} was successfully updated.'" %>
    else
      render action: 'edit'
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= parent_singular_table_name %>_<%= plural_table_name %>_path(@<%= parent_singular_table_name %>), notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= parent_name.tableize.singularize %>
      @<%= parent_name.tableize.singularize %> = <%= orm_class.find(parent_name, "params[:" + parent_name.tableize.singularize + "_id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
