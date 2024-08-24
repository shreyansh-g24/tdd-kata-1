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
      assert_equal add(""), 0
    end

    it "add returns n if only 1 integer is provided" do
      assert_equal add("1"), 1
      assert_equal add("2"), 2
      assert_equal add("3"), 3
      assert_equal add("1234567"), 1234567
    end

    it "returns the sum if 2 integers are provided separated by commas" do
      assert_equal add("1,2"), 3
      assert_equal add("3,4"), 7
      assert_equal add("11,21"), 32
      assert_equal add("123,2"), 125
      assert_equal add("1,234"), 235
    end

    it "returns the sum for any amount of numbers are provided separated by commas" do
      assert_equal add("1,2,3,4,5"), 15
      assert_equal add("1,2,323"), 326
      assert_equal add("112,0,32"), 144
      assert_equal add("1,1,1,1,1,1,1,1,1,1"), 10
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

    numbers.split(",").sum(&:to_i)
  end
end
