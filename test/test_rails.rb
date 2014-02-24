require 'cursive/rails'

class Cursive::UserSerializer < Cursive::Serializer
end

class Cursive::LocationSerializer < Cursive::Serializer
end

class Cursive::PropertySerializer < Cursive::LocationSerializer
end

class TestRails < TestBase
  def test_serializer_names
    assert_equal Cursive::UserSerializer,
                 ::Cursive::Rails::serializer_for_controller_name('UsersController')
    assert_equal Cursive::UserSerializer,
                 ::Cursive::Rails::serializer_for_controller_name('UserController')
  end

  def test_build_serializer
    serializer = ::Cursive::Rails::build_serializer('UsersController',
                                                    small_user_table)
    assert serializer.is_a?(Cursive::UserSerializer)

    serializer = ::Cursive::Rails::build_serializer('NothingsController',
                                                    small_user_table)
    assert_nil serializer
  end
end