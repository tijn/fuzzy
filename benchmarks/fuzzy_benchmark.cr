require "benchmark"
require "../src/fuzzy"

# This is the implementation of `String#index` at the time of writing:
#
# def index(search : Char, offset = 0)
#   # If it's ASCII we can delegate to slice
#   if search.ascii? && ascii_only?
#     return to_slice.index(search.ord.to_u8, offset)
#   end
#
#   offset += size if offset < 0
#   return nil if offset < 0
#
#   each_char_with_index do |char, i|
#     if i >= offset && char == search
#       return i
#     end
#   end
#
#   nil
# end
#
# If the string isn't ASCII then it falls back to a less optimal algorithm wherin it has to repeatedly loop over the chars before the offset. It has to do it this way because it cannot know how many bytes a character will take.

module Fuzzy
  class NaivePattern < Pattern
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
  end

  class IteratorPattern < Pattern
    def match?(string : String)
      return false if string.size < @pattern.size

      iterator = string.each_char
      @pattern.each_char do |char|
        any_next_char_match?(iterator, char) || return false
      end
      true
    end

    private def any_next_char_match?(iterator, needle)
      loop do
        char = iterator.next
        return false if char.is_a? Iterator::Stop::INSTANCE
        return true if char == needle
      end
      false
    end
  end

  class Iterator2Pattern < Pattern
    # let's see if the extra method is slowing it down
    def match?(string : String)
      return false if string.size < @pattern.size

      iterator = string.each_char
      @pattern.each_char do |char|
        loop do
          ch = iterator.next
          return false if ch.is_a? Iterator::Stop::INSTANCE
          break if ch == char
        end
      end
      true
    end
  end

  class ArrayPattern < Pattern
    def match?(string : String)
      return false if string.size < @pattern.size

      chars = string.chars
      offset = 0
      @pattern.each_char do |char|
        index = chars.index(char, offset)
        return false if index.nil?
        offset = index + 1
      end
      true
    end
  end

  class CodepointsPattern < Pattern
    def match?(string : String)
      return false if string.size < @pattern.size

      codepoints = string.codepoints
      offset = 0
      @pattern.each_char do |char|
        index = codepoints.index(char.ord, offset)
        return false if index.nil?
        offset = index + 1
      end
      true
    end
  end

  class CharReaderPattern < Pattern
    def initialize(@pattern : String)
      @p = Char::Reader.new(pattern)
    end

    def match?(string : String)
      p = @p
      p.pos = 0
      s = Char::Reader.new(string)
      loop do
        if p.current_char == s.current_char
          break true unless p.has_next?
          p.next_char
        end
        break false unless s.has_next?
        s.next_char
      end
    end
  end
end

naive = Fuzzy::NaivePattern.new("bar")
iterator = Fuzzy::IteratorPattern.new("bar")
iterator2 = Fuzzy::Iterator2Pattern.new("bar")
array = Fuzzy::ArrayPattern.new("bar")
codepoints = Fuzzy::CodepointsPattern.new("bar")
char_reader = Fuzzy::CharReaderPattern.new("bar")

puts "ASCII:"
word = "foo foo foo foo  fooafa fooooooo weatherboards"
Benchmark.ips do |ips|
  ips.report("naive") { naive.match? word }
  ips.report("iterator") { iterator.match? word }
  ips.report("iterator2") { iterator2.match? word }
  ips.report("array") { array.match? word }
  ips.report("codepoints") { codepoints.match? word }
  ips.report("char_reader") { char_reader.match? word }
end

puts ""
puts "Unicode:"
unicode = "foo foo foo fø漢oo  fooafa fooooooo weatherboards"
Benchmark.ips do |ips|
  ips.report("naive") { naive.match? unicode }
  ips.report("iterator") { iterator.match? unicode }
  ips.report("iterator2") { iterator2.match? unicode }
  ips.report("array") { array.match? unicode }
  ips.report("codepoints") { codepoints.match? unicode }
  ips.report("char_reader") { char_reader.match? unicode }
end
