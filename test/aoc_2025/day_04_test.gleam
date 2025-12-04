import gleeunit/should
import aoc_2025/day_04
import simplifile
import gleam/result

const example_input = "..@@.@@@@.\n@@@.@.@.@@\n@@@@@.@.@@\n@.@@@@..@.\n@@.@@@@.@@\n.@@@@@@@.@\n.@.@.@.@@@\n@.@@@.@@@@\n.@@@@@@@@.\n@.@.@@@.@."

pub fn part1_example_test() {
  day_04.part1(example_input)
  |> should.equal(13)
}

pub fn part1_regression_test() {
  let puzzle_input = simplifile.read("input/2025/04.txt") |> result.unwrap("")
  day_04.part1(puzzle_input)
  |> should.equal(1344)
}

pub fn part2_regression_test() {
  let puzzle_input = simplifile.read("input/2025/04.txt") |> result.unwrap("")
  day_04.part2(puzzle_input)
  |> should.equal(8112)
}

pub fn part2_example_test() {
  day_04.part2(example_input)
  |> should.equal(43)
}
