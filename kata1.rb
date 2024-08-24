require "minitest/autorun"

class Kata1Test < Minitest::Test
  def setup
    @kata = Kata1.new
  end

  def test_add_raises_error_when_input_is_not_string
    assert_raises(Kata1::InvalidInput, "Input must be string") { add(nil) }
    assert_raises(Kata1::InvalidInput, "Input must be string") { add(1) }
    assert_raises(Kata1::InvalidInput, "Input must be string") { add(Class) }
    assert_raises(Kata1::InvalidInput, "Input must be string") { add(true) }
  end

  def test_add_returns_integer
    assert_kind_of Integer, add("")
  end

  private

  def add(input)
    @kata.add(input)
  end
end

class Kata1
  class Kata1::InvalidInput < Exception
    def self.raise_error
      raise self, "Input must be string"
    end
  end

  def add(numbers)
    Kata1::InvalidInput.raise_error unless numbers.is_a?(String)

    0
  end
end
