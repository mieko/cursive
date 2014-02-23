class TestCursive < TestBase

  def test_blank_serializer
    m = define_serializer do
      # default values
    end
  end

  def test_explicit_attributes
    # also ensures serializer order is obeyed.
    m = define_serializer do
      attribute :station
      attribute :name
      attribute :rank
    end

    valid = [
      ['NCC-1701-D', 'Data',       'ltc'],
      ['NCC-74656',  'Janeway',    'capt'],
      ['NCC-1701-D', 'Picard',     'capt'],
      ['',           'Q',          ''],
      ['DS9',        'Quark',      ''],
      ['NCC-1701',   'Spock',      'cmdr'],
      ['NCC-74656',  'The Doctor', ''],
      ['DS9',        'Worf',       'ltc'],
    ]

    m.render(user_table).zip(valid).each do |got, expected|
      assert_equal expected, got
    end
  end

  # We should be able to set a default value that applies to all attributes
  def test_serializer_defaults
    m = define_serializer do |cls|
      attribute :name
      attribute :station
      attribute :rank

      cls.send(:define_method, :default_value) do
        'SERIALIZER_NONE'
      end
    end

    valid = [
      %w(Data  NCC-1701-D      ltc),
      %w(Q     SERIALIZER_NONE SERIALIZER_NONE),
      %w(Quark DS9             SERIALIZER_NONE)
    ]

    m.render(small_user_table).zip(valid).each do |got, expected|
      assert_equal expected, got
    end
  end

  # We should be able to set a default value for an attribute on a per-attribute
  # level.  The default_value method should continue to be a fallback, however.
  def test_attribute_defaults
    m = define_serializer do |cls|
      attribute :name
      attribute :station, default: 'ATTRIBUTE_NONE'
      attribute :rank

      cls.send(:define_method, :default_value) do
        'SERIALIZER_NONE'
      end
    end

    valid = [
      %w(Data  NCC-1701-D     ltc),
      %w(Q     ATTRIBUTE_NONE SERIALIZER_NONE),
      %w(Quark DS9            SERIALIZER_NONE)
    ]

    m.render(small_user_table).zip(valid).each do |got, expected|
      assert_equal expected, got
    end
  end



end