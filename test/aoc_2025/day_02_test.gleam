import aoc_2025/day_02
import gleeunit/should
import simplifile
import gleam/result

pub fn part1_test() {
  let example_input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,\n1698522-1698528,446443-446449,38593856-38593862,565653-565659,\n824824821-824824827,2121212118-2121212124"
  day_02.part1(example_input)
  |> should.equal(1_227_775_554)
}

pub fn part1_regression_test() {
  let puzzle_input = simplifile.read("input/2025/02.txt") |> result.unwrap("")
  day_02.part1(puzzle_input)
  |> should.equal(16_793_817_782)
}

pub fn part2_test() {
  let example_input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,\n1698522-1698528,446443-446449,38593856-38593862,565653-565659,\n824824821-824824827,2121212118-2121212124"
  day_02.part2(example_input)
  |> should.equal(4_174_379_265)
}

pub fn part2_regression_test() {
  let puzzle_input = simplifile.read("input/2025/02.txt") |> result.unwrap("")
  day_02.part2(puzzle_input)
  |> should.equal(27_469_417_404)
}