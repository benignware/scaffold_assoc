#require 'rails/generators/rails/scaffold/scaffold_generator'
#require File.join(File.dirname(__FILE__), '../scaffold_association_controller/association_named_base')

module Rails
  module Generators
    class ScaffoldAssocGenerator < NamedBase  # :nodoc:
      
      include Rails::Generators::Migration
      
      attr_accessor :parent_name, :flags
      
      source_root File.expand_path('../templates', __FILE__)
      
      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
      
      class_option :orm, :banner => "NAME", :type => :string, :required => true, :default => :active_record, 
                       :desc => "ORM to generate the controller for"
      
      class_option :skip_model, :type => :boolean, :default => false, :desc => "Don't generate a model or migration."    
      class_option :skip_migration, :type => :boolean, :default => false, :desc => "Don't generate migration for model."
      class_option :skip_controller, :type => :boolean, :default => false, :desc => "Don't generate controller for model."
      class_option :skip_views, :type => :boolean, :default => false, :desc => "Don't generate views for model."
      
      hook_for :form_builder, :as => :scaffold
      
      def initialize(args, *options)
        a = args[0].split("/")
        self.parent_name = a[0]
        name = a[1]
        args[0] = name
        super
        assign_controller_names!(self.name)
      end
      
      def create_migration
        if options[:skip_model] || options[:skip_migration]
          return
        end
        migration_template 'migration.rb', File.join('db/migrate/', "create_" + plural_table_name + ".rb")
      end
      
      def self.next_migration_number(path)
        @migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(@migration_number)
      end
      
      def create_model
        if options[:skip_model]
          return
        end
        template 'model.rb', File.join('app/models', singular_table_name + ".rb")
      end
      
      def create_controller_files
        if options[:skip_controller]
          return
        end
        template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      end
      
      def copy_view_files
        if options[:skip_views]
          return
        end
        available_views.each do |view|
          filename = [view, 'html', handler].compact.join(".")
          template "#{handler}/#{view}.html.#{handler}", File.join("app/views", controller_file_path, filename)
        end
      end
      
    protected

      attr_reader :controller_name, :controller_file_name
      
      def available_views
        %w(index edit show new _form)
      end

      def handler
        :haml
      end
      
      def parent_table_name
        return parent_name.tableize
      end
      
      def parent_singular_table_name
        return parent_table_name.singularize
      end
      
      def controller_class_path
        if options[:model_name]
          @controller_class_path
        else
          class_path
        end
      end

      def assign_controller_names!(name)
        @controller_name = name
        @controller_class_path = name.include?('/') ? name.split('/') : name.split('::')
        @controller_class_path.map! { |m| m.underscore }
        @controller_file_name = @controller_class_path.pop
      end

      def controller_file_path
        @controller_file_path ||= (controller_class_path + [controller_file_name]).join('/')
      end

      def controller_class_name
        (controller_class_path + [controller_file_name]).map!{ |m| m.camelize }.join('::')
      end

      def controller_i18n_scope
        @controller_i18n_scope ||= controller_file_path.tr('/', '.')
      end

      # Loads the ORM::Generators::ActiveModel class. This class is responsible
      # to tell scaffold entities how to generate an specific method for the
      # ORM. Check Rails::Generators::ActiveModel for more information.
      def orm_class
        @orm_class ||= begin
          # Raise an error if the class_option :orm was not defined.
          unless self.class.class_options[:orm]
            raise "You need to have :orm as class option to invoke orm_class and orm_instance"
          end

          begin
            "#{options[:orm].to_s.camelize}::Generators::ActiveModel".constantize
          rescue NameError
            Rails::Generators::ActiveModel
          end
        end
      end

      # Initialize ORM::Generators::ActiveModel to access instance methods.
      def orm_instance(name=singular_table_name)
        @orm_instance ||= orm_class.new(name)
      end
    
    end
  end
end
