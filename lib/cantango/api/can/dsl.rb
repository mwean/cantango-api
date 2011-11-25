module CanTango::Api
  module Can
    module Dsl
      autoload_modules :Relation, :Scope
      
      def self.included(base)
        ::CanTango.config.user.relations.each do |relationship|
          base.class_eval %{
            def #{relationship}_of *models, &block
              options = models.extract_options!
              scope = options[:scope] || :user_account
              relation = Relation.new :#{relationship}, self, scope, *models, &block
              yield relation if block
              relation
            end
          }
        end
      end

      # creates a scope that enforces either using the user or user_account for determining relationship matches on the models
      def scope name, &block
        yield Scope.new name, self, &block
      end
    end
  end
end
