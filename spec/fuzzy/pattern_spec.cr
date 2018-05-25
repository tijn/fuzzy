require "../spec_helper"

describe Fuzzy::Pattern do
  describe "#=~" do
    bar = Fuzzy::Pattern.new("bar")

    it "matches the exact same string" do
      bar.should match("bar")
    end

    it "matches a string with postfix" do
      bar.should match("barquux")
    end

    it "matches a string with prefix" do
      bar.should match("foobar")
    end

    it "matches a string with infixes" do
      bar.should match("bqaur")
    end

    it "matches a string with pre, post, and infixes" do
      bar.should match("qbuaurx")
      bar.should match("laboratory")
    end

    it "won't match a partial match" do
      bar.should_not match("baz")
    end

    it "won't match a different string" do
      bar.should_not match("quux")
    end
  end

  describe "#==" do
    it "compares with Patterns" do
      (Fuzzy::Pattern.new("bar") == Fuzzy::Pattern.new("bar")).should be_true
      (Fuzzy::Pattern.new("bar") == Fuzzy::Pattern.new("baz")).should be_false
    end

    it "returns false when comparing with non-Patterns" do
      (Fuzzy::Pattern.new("bar") == "bar").should be_false
    end
  end

  describe "#===" do
    it "compares with Patterns" do
      (Fuzzy::Pattern.new("bar") === Fuzzy::Pattern.new("bar")).should be_true
      (Fuzzy::Pattern.new("bar") === Fuzzy::Pattern.new("baz")).should be_false
    end

    it "compares with Strings" do
      (Fuzzy::Pattern.new("bar") === "bar").should be_true
      (Fuzzy::Pattern.new("bar") === "baz").should be_false
    end

    it "doesn't compare with Symbols" do
      (Fuzzy::Pattern.new("bar") === :bar).should be_false
      (Fuzzy::Pattern.new("bar") === :baz).should be_false
    end
  end

  describe "#match" do
    foo = Fuzzy::Pattern.new("foo")

    it "returns nil for a non-match" do
      foo.match("bar").should be_nil
    end

    it "returns matching indices for a match" do
      foo.match("reforestation").should eq [2, 3, 11]
    end
  end
end
