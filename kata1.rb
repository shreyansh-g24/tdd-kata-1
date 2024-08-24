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
      assert_equal 123, add("123")
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

    it "returns the sum if the numbers are separated by a single character custom delimeter (other than - , \\n, [, ], - and other special characters)" do
      assert_equal 15, add("//;\n1;2;3;4;5")
      assert_equal 326, add("//x\n1x2x323")
      assert_equal 326, add("//.\n1.2.323")
      assert_equal 15, add("//^\n1^2^3^4^5")
    end

    it "raises NegativesNotAllowed if negative numbers are passed. Also returns the negatives in an error message" do
      assert_raises(Kata1::NegativesNotAllowed, "Negative not allowed - -1") { add("//;\n-1;2;3;4;5") }
      assert_raises(Kata1::NegativesNotAllowed, "Negative not allowed - -2,-323") { add("//x\n1x-2x-323") }
      assert_raises(Kata1::NegativesNotAllowed, "Negative not allowed - -1,-323") { add("-1\n2,-323") }
    end

    it "ignores numbers bigger than 1000" do
      assert_equal 15, add("//;\n1;2;3;1001;4;5")
      assert_equal 1326, add("//x\n2000x1x1000x2x323")
      assert_equal 326, add("//.\n1.2.323.1002")
      assert_equal 1014, add("//^\n1^2^999^10002^3^4^5")
    end

    it "custom delimiters can be any length when enclosed in square brackets (other than - , \\n, [, ], - and other special characters)" do
      assert_equal 15, add("//[;;]\n1;;2;;3;;4;;5")
      assert_equal 326, add("//[abc]\n1abc2abc323")
      assert_equal 326, add("//[.^%]\n1.^%2.^%323")
      assert_equal 15, add("//[!!!]\n1!!!2!!!3!!!4!!!5")
    end

    it "multiple single character custom delimiters can be provided enclosed in square brackets (other than - , \\n, [, ], - and other special characters)" do
      assert_equal 15, add("//[;][.][%]\n1;2.3%1001;4%5")
      assert_equal 1326, add("//[x][y][z]\n2000x1z1000y2z323")
      assert_equal 326, add("//[.][q][|]\n1.2|323q1002")
      assert_equal 1014, add("//[^][+]\n1+2^999+10002+3^4^5")
    end

    it "multiple multi character custom delimiters can be provided enclosed in square brackets (other than - , \\n, [, ], - and other special characters)" do
      assert_equal 15, add("//[;x][..][%!]\n1;x2..3%!1001;x4%!5")
      assert_equal 1326, add("//[x`][@y][#z]\n2000x`1#z1000@y2#z323")
      assert_equal 326, add("//[abc][qwe][|$%]\n1abc2|$%323qwe1002")
      assert_equal 1014, add("//[|^][++]\n1++2|^999++10002++3|^4|^5")
    end

    def add(input)
      kata.add(input)
    end
  end
end

class Kata1
  class InvalidInput < Exception
    def self.raise_error
      raise self, "Input must be string"
    end
  end

  class NegativesNotAllowed < Exception
    def self.raise_error(negatives)
      raise self, "Negatives not allowed - #{negatives.join(",")}"
    end
  end

  def add(numbers)
    InvalidInput.raise_error unless numbers.is_a?(String)
    return 0 if numbers.length.zero?

    numbers_int = get_numbers_as_int(numbers)
    verify_negatives(numbers_int)
    sum(numbers_int)
  end

  def get_delimiter_regex(first_line)
    if first_line.start_with?("//")
      delimiters = parse_custom_delimiter(first_line)
      [true, /(#{delimiters.map { |d| Regexp.quote(d) }.join("|")}){1}/]
    else
      [false, /[,\n]{1}/]
    end
  end

  def parse_custom_delimiter(first_line)
    if [nil, 1].include?(first_line.split("").tally["["])
      return [first_line.gsub(/[\/\/\[\]]/, '')]
    end

    first_line.gsub("//", "").scan(/\[(.*?)\]/).map(&:first)
  end

  def get_numbers_as_int(numbers)
    lines = numbers.split(/\n/)
    is_custom_delimiter, delimiter_regex = get_delimiter_regex(lines[0])
    joined = is_custom_delimiter ? lines[1..].join("\n") : lines.join("\n")
    joined.split(delimiter_regex).map(&:to_i)
  end

  def verify_negatives(numbers)
    negatives = numbers.select(&:negative?)
    NegativesNotAllowed.raise_error(negatives) if negatives.length.positive?
  end

  def sum(numbers)
    numbers.sum { |n| n > 1000 ? 0 : n }
  end
end
