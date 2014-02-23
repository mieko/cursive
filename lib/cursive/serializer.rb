require 'cursive/attribute'

module Cursive
  class Serializer
    class << self
      def attributes
        @attributes ||= []
        @attributes
      end

      def attribute(*args, **kwargs)
        attributes.push(Attribute.new(*args, **kwargs))
      end

      def render(collection)
        new.render(collection)
      end
    end

    def render_header?
      true
    end

    def default_value
      ''
    end

    def render_header
      self.class.attributes.map do |attribute|
        attribute.name
      end
    end

    def call_with_object(method_name, object)
      m = method(method_name)
      (m.arity.abs == 1) ? m.call(object) : m.call
    end

    def render(collection)
      return enum_for(__method__, collection) unless block_given?

      render_header if render_header?

      collection.each do |item|
        yield render_one(item)
      end
    end

    def render_one(object)
      self.class.attributes.map do |attribute|
        cast(value_for_attribute(attribute, object))
      end
    end

    def cast(obj)
      obj.to_s
    end

    def value_for_attribute(attribute, object)
      [self, object].each do |target|
        if target.respond_to?(attribute.method_name)
          rval = target.send(attribute.method_name)
          return rval unless rval.nil?
        end
      end

      return attribute.default || call_with_object(:default_value, object)
    end

  end
end