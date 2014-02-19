module ScaffoldAssoc
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      
      desc <<DESC
  Description:
  Copy scaffold_assoc view templates to your application.
DESC
  
      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), '../templates'))
      end
        
      def install
        directory 'erb', 'lib/rails/scaffold_assoc/templates/erb'
        directory 'haml', 'lib/rails/scaffold_assoc/templates/haml'
      end
      
    end
  end
end