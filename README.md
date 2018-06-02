# fuzzy

Fuzzy finder algorithm. Fuzzy like [fzf](https://github.com/junegunn/fzf) or ctrl+t in vim or cmd+p in Sublime Text or Visual Studio. It's not [blue](https://www.youtube.com/watch?v=2NSdNtOktHE) though.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  fuzzy:
    github: tijn/fuzzy
```

## Usage

You can use a `Fuzzy::Pattern` like a `Regex`. It supports a similar interface:

```crystal
require "fuzzy"

pattern = Fuzzy::Pattern.new("needle") # in a haystack

# see if it matches a string
pattern.match? "this needle cushion" # => true
pattern =~ "that needle cushion" # => true

# see which characters are matched
pattern.match "those needle cushions" # => [6, 7, 8, 9, 10, 11]
Fuzzy::Pattern.new("foo").match("reforestation") # => [2, 3, 11]

# case equality
STDIN.each_line do |line|
case line
when ''
  # empty line
when pattern
  # it matches your pattern (needle)
else
  # dunno?
end
```

## Development

I experimented with several variations of the algorithm. You can find them in `benchmarks/fuzzy_benchmark.cr`.

There isn't much variation in the results. Typical output on my computer looks like this:

```
ASCII:
      naive  48.75M ( 20.51ns) (± 3.62%)       fastest
   iterator   4.11M (243.49ns) (± 5.99%) 11.87× slower
  iterator2   4.34M ( 230.2ns) (± 5.04%) 11.22× slower
      array   3.68M (271.78ns) (± 2.39%) 13.25× slower
 codepoints   3.61M (277.14ns) (± 4.17%) 13.51× slower
char_reader   6.84M (146.24ns) (± 1.23%)  7.13× slower

Unicode:
      naive   4.56M (219.37ns) (± 1.42%)  1.41× slower
   iterator   3.72M ( 268.8ns) (± 3.52%)  1.72× slower
  iterator2   3.83M (261.27ns) (± 4.94%)  1.67× slower
      array   2.99M (334.87ns) (± 5.24%)  2.14× slower
 codepoints   2.99M (334.19ns) (± 4.83%)  2.14× slower
char_reader   6.41M (156.13ns) (± 2.33%)       fastest
```

I decided to keep the naive algorithm as the default for now.

## Contributing

1. Fork it ( https://github.com/tijn/fuzzy/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tijn](https://github.com/tijn) Tijn Schuurmans - creator, maintainer
