module Fuzzy
  class Pattern
    getter pattern

    def initialize(@pattern : String)
    end

    # Returns the `Pattern` as a `String`
    def to_s(io : IO)
      io << @pattern
    end

    def =~(string : String)
      match?(string)
    end

    # Matches a regular expression against `String` *string*
    # returns *true* or *false*.
    def match?(string : String)
      return false if string.size < @pattern.size

      offset = 0
      @pattern.each_char do |char|
        index = string.index(char, offset)
        return false if index.nil?
        offset = index + 1
      end
      true
    end

    # Case equality
    def ===(string : String)
      match?(string)
    end

    # Case equality
    def ===(pattern : Pattern)
      self == pattern
    end

    # Case equality
    def ===(object)
      false
    end

    # Concatenation
    def +(string : String)
      Pattern.new(@pattern + string)
    end

    # Concatenation
    def +(other : Pattern)
      self + other.pattern
    end

    def_clone
    # Two `Pattern`s are equal if their *@pattern*s match
    def_equals(@pattern)
    def_hash(@pattern)

    # Matches a regular expression against `String` *string*
    # Returns an `Array` with matching indices if *string* matched, otherwise `nil`.
    def match(string : String)
      return nil if string.size < @pattern.size

      offset = 0
      indices = [] of Int32
      @pattern.each_char do |char|
        index = string.index(char, offset)
        return nil if index.nil?
        indices << index
        offset = index + 1
      end
      indices
    end
  end
end
