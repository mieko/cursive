require 'active_support/core_ext/string/inflections'

module Cursive
  module Rails

    module_function \
    def serializer_for_controller_name(controller_name)
      ser_name = controller_name.gsub(/Controller\z/, '')
      ser_name = "Cursive::#{ser_name.singularize}Serializer"
      begin
        Object.const_get(ser_name)
      rescue NameError
        nil
      end
    end

    module_function \
    def build_serializer(controller_name, collection, options = {})
      serializer = options[:cursive_serializer]
      serializer ||= serializer_for_controller_name(controller_name)
      serializer && serializer.new(collection)
    end

  end
end

if defined?(::Rails)
  ActiveSupport.on_load(:action_controller) do


    class Cursive::Serializer
      include Rails.application.routes.url_helpers
    end


    # Add config/cursive to the autoload path
    # serializer_dir = Rails.root.join("serializers/cursive").to_s
    # Rails.application.config.autoload_paths += [serializer_dir]

    # Take over :csv handling.
    ActionController::Renderers.add :csv do |obj, options|
      serializer = ::Cursive::Rails::build_serializer(self.class.name, obj, options)

      if serializer.nil?
        raise ArgumentError,
          "couldnt find cursive serializer for `#{self.class.name}'.  " +
          "perhaps pass :cursive_serializer explicitly?"
      end

      send_data serializer.render_text, type: 'text/plain'
    end
  end
end