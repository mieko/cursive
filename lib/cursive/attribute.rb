module Cursive
  class Attribute
    attr_reader :name
    attr_reader :method_name
    attr_reader :default

    def initialize(name, method_name: nil, default: nil)
      method_name ||= name
      @name, @method_name, @default = name, method_name, default
    end
  end
end