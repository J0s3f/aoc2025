import aoc_2025/day_01
import gleeunit/should
import simplifile
import gleam/result

pub fn part1_test() {
  let input =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"
  day_01.part1(input)
  |> should.equal(3)
}

pub fn part1_regression_test() {
  let puzzle_input = simplifile.read("input/2025/01.txt") |> result.unwrap("")
  day_01.part1(puzzle_input)
  |> should.equal(1100)
}

pub fn part2_test() {
  let input =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"
  day_01.part2(input)
  |> should.equal(6)
}

pub fn part2_regression_test() {
  let puzzle_input = simplifile.read("input/2025/01.txt") |> result.unwrap("")
  day_01.part2(puzzle_input)
  |> should.equal(6358)
}