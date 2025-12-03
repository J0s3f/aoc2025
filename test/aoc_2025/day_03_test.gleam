import aoc_2025/day_03
import gleeunit/should
import gleam/string
import simplifile
import gleam/result

pub fn part1_example_test() {
  let example = "987654321111111
811111111111119
234234234234278
818181911112111"
  day_03.part1(example)
  |> should.equal(357)
}

pub fn part1_regression_test() {
  let puzzle_input = simplifile.read("input/2025/03.txt") |> result.unwrap("")
  day_03.part1(puzzle_input)
  |> should.equal(17330)
}

pub fn part2_example_test() {
  let example = "987654321111111
811111111111119
234234234234278
818181911112111"
  day_03.part2(example)
  |> should.equal(3121910778619)
}

pub fn part2_regression_test() {
  let puzzle_input = simplifile.read("input/2025/03.txt") |> result.unwrap("")
  day_03.part2(puzzle_input)
  |> should.equal(171518260283767)
}
