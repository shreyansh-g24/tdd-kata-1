require "minitest/autorun"

class Kata1Test < Minitest::Test
  describe "#add" do
    let(:kata) { Kata1.new }

    it "add raises error when input is not string" do
      assert_raises(Kata1::InvalidInput, "Input must be string") { add(nil) }
      assert_raises(Kata1::InvalidInput, "Input must be string") { add(1) }
      assert_raises(Kata1::InvalidInput, "Input must be string") { add(Class) }
      assert_raises(Kata1::InvalidInput, "Input must be string") { add(true) }
    end

    it "add returns integer" do
      assert_kind_of Integer, add("")
    end

    it "add returns 0 for empty string" do
      assert_equal 0, add("")
    end

    it "add returns n if only 1 integer is provided" do
      assert_equal 1, add("1")
      assert_equal 2, add("2")
      assert_equal 3, add("3")
      assert_equal 1234567, add("1234567")
    end

    it "returns the sum if 2 integers are provided separated by commas" do
      assert_equal 3, add("1,2")
      assert_equal 7, add("3,4")
      assert_equal 32, add("11,21")
      assert_equal 125, add("123,2")
      assert_equal 235, add("1,234")
    end

    it "returns the sum for any amount of numbers are provided separated by commas" do
      assert_equal 15, add("1,2,3,4,5")
      assert_equal 326, add("1,2,323")
      assert_equal 144, add("112,0,32")
      assert_equal 10, add("1,1,1,1,1,1,1,1,1,1")
    end

    it "returns the sum if the numbers are provided separated by either a comma or a newline" do
      assert_equal 15, add("1,2,3\n4\n5")
      assert_equal 326, add("1\n2,323")
    end

    def add(input)
      kata.add(input)
    end
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
    return 0 if numbers.length.zero?

    numbers.split(/[,\n]{1}/).sum(&:to_i)
  end
end
