#encoding: utf-8
#author: tteng
#override Sunspot::Mongoid::DataAccessor::BSON 
#to fix uninitialized constant Sunspot::Mongoid::DataAccessor::BSON bug
#target version: sunspot_mongoid/0.4.1

module Sunspot

  module Mongoid

    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)

        after_save do
          Sunspot.index! self
        end

        after_delete do
          Sunspot.remove! self
        end

        after_destroy do
          Sunspot.remove! self
        end

      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor

      def load(id)
        @clazz.criteria.for_ids(Moped::BSON::ObjectId(id))
      end

      def load_all(ids)
        @clazz.criteria.in(:_id => ids.map {|id| Moped::BSON::ObjectId(id)})
      end

    end

  end

end
