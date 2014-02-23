$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'cursive'

class User
  attr_accessor :name
  attr_accessor :station
  attr_accessor :rank

  def initialize(**kwargs)
    kwargs.each do |k, v|
      send("#{k}=", v)
    end
  end

  def to_param
    r = name.dup!
    r.downcase!
    r.gsub!(/[^a-z0-9]/i, '-')
    r.gsub!(/-+/, '-')
    r
  end
end

class TestBase < Minitest::Test

  # Gives us a nice way to define a serializer which can be created within
  # test methods.
  def define_serializer(&block)
    Class.new(Cursive::Serializer).tap do |serializer|
      serializer.instance_exec(serializer, &block)
    end
  end

  def user_table
    [ User.new(name: 'Data',       station: 'NCC-1701-D', rank: :ltc),
      User.new(name: 'Janeway',    station: 'NCC-74656',  rank: :capt),
      User.new(name: 'Picard',     station: 'NCC-1701-D', rank: :capt),
      User.new(name: 'Q',          station: nil,          rank: nil),
      User.new(name: 'Quark',      station: 'DS9',        rank: nil),
      User.new(name: 'Spock',      station: 'NCC-1701',   rank: :cmdr),
      User.new(name: 'The Doctor', station: 'NCC-74656',  rank: nil),
      User.new(name: 'Worf',       station: 'DS9',        rank: :ltc) ]
  end

  def small_user_table
    user_table.select do |r|
      %w(Data Q Quark).include?(r.name)
    end
  end

end
