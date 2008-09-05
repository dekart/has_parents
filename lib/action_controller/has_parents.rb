unless RUBY_VERSION =~ /^1\.9/
  gem("collections")
  require "collections/sequenced_hash"
end

module ActionController
  module HasParents
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      attr_accessor_with_default :parent_keys, []

      def has_parents(*args)
        self.parent_keys = args.map(&:to_sym)
      end
    end

    module InstanceMethods
      # Protecting parent search methods from being called as controller actions
      protected
      
      def parent_keys
        return self.class.parent_keys unless self.class.parent_keys.empty?
        
        request.path_parameters.keys.map{|key|
          key.match(/^(.*)_id$/).to_a[1]
        }.compact
      end
      
      def parents
        return @_parent_objects unless @_parent_objects.nil?

        @_parent_objects = (begin SequencedHash rescue Hash end).new

        parent_keys.each do |key|
          if parent = parent_by_key(key)
            @_parent_objects[key] = parent
          end
        end

        @_parent_objects
      end

      def parent_by_key(key)
        begin
          klass = key.to_s.classify.constantize
          
          klass.find_by_id(params["#{key}_id"])
        rescue
        end
      end
    end
  end
end