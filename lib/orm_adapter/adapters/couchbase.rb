require 'orm_adapter'
require 'couchbase/model'

# This is an orm_adapter gem implementation for Couchbase.
module OrmAdapter
  class Couchbase < OrmAdapter::Base

    # Return list of column/property names
    def column_names
      klass.attributes.keys
    end

    # @see OrmAdapter::Base#get!
    def get!(id)
      klass.find(wrap_key(id))
    end

    # @see OrmAdapter::Base#get
    def get(id)
      klass.find_by_id(wrap_key(id))
    end

    # @see OrmAdapter::Base#find_first
    def find_first(options = {})
      rs = find_with_options(options)
      rs.empty? ? nil : rs.first
    end

    # @see OrmAdapter::Base#find_all
    def find_all(options = {})
      rs = find_with_options(options)
    end

    # @see OrmAdapter::Base#create!
    def create!(attributes = {})
      klass.create!(attributes)
    end

    # @see OrmAdapter::Base#destroy
    def destroy(object)
      object.delete && true if valid_object?(object)
    end

  protected

    # Since we only support searches by unique indexes, we always return
    # an empty array for not found, or an array with the found element.
    def find_with_options(options)
      conditions, order, limit, offset = extract_conditions!(options)
      index, key = conditions_to_view_and_key(conditions)
      if index.nil?
        raise "Find without conditions not supported."
      else
        [ klass.return_model_for_unique_index_and_value(index, key) ].compact
      end
    end

    # Going to return a couchbase view name for single attributes.  If no conditions, return the 'all' view.
    # TBD: support multiple conditions, such as: by_email_and_first_name, which will assume a view
    # naming convention...
    def conditions_to_view_and_key(conditions)
      if conditions.is_a?(Hash)
        if conditions.empty?
          return nil, nil
        else # has as an array
          k = conditions.keys.first
          return k, conditions[k]
        end
      else
        raise 'Only supports hashes.'
      end
    end
  end
end

# Essentially, any Couchbase::Model instance needs to be able to call (instance).class.to_adapter
# to get the above loaded for devise.
module Couchbase
  Model.extend OrmAdapter::ToAdapter
  Model::OrmAdapter = OrmAdapter::Couchbase
end
