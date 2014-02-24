require 'cursive/attribute'

module Cursive
  class Serializer
    class << self

      # When a Serializer is inherited, copy its state into the subclass
      def inherited(cls)
        parent_attributes = instance_variable_get(:@attributes) || []
        cls.instance_variable_set(:@attributes, parent_attributes.dup)

        super
      end

      def attributes
        @attributes ||= []
        @attributes
      end

      # defines an attribute
      def attribute(*args, **kwargs)
        attributes.push(Attribute.new(*args, **kwargs))
      end

      def render(collection)
        new(collection).render
      end
    end

    def render_header?
      true
    end

    def default_value(object, attribute_name)
      ''
    end

    def initialize(collection)
      @collection = collection
    end

    def render
      return enum_for(__method__) unless block_given?

      render_header if render_header?

      @collection.each do |item|
        yield render_one(item)
      end
    end

    def render_text
      render.to_a.each do |record|
        record.join ","
      end.join "\n"
    end

    private
    def render_header
      self.class.attributes.map do |attribute|
        attribute.name
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
      # First, try the serializer, with self.attr_name(obj)
      if respond_to?(attribute.method_name)
        rval = send(attribute.method_name, object)
        return rval unless rval.nil?
      end

      # Then try the model, with object.attr_name
      if object.respond_to?(attribute.method_name)
        rval = object.send(attribute.method_name)
        return rval unless rval.nil?
      end

      # Then try the attribute default specified, and finally, give
      # serializer.default_value(object, attr_name) a chance to answer.
      return attribute.default || default_value(object, attribute.name)
    end

  end
end