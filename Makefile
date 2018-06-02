all: fuzzy_benchmark

fuzzy_benchmark: benchmarks/fuzzy_benchmark.cr
	crystal build --release -o fuzzy_benchmark benchmarks/fuzzy_benchmark.cr
