import gleam/int
import gleam/list
import gleam/string

fn floor_divide(a: Int, b: Int) -> Int {
  let quotient = case int.divide(a, b) {
    Ok(q) -> q
    Error(_) -> 0
  }
  case a < 0 && int.modulo(a, b) != Ok(0) {
    True -> quotient - 1
    False -> quotient
  }
}

fn process_line(state: #(Int, Int), line: String) -> #(Int, Int) {
  case string.is_empty(line) {
    True -> state
    False -> {
      let #(current_pos, zero_count) = state
      let direction = string.slice(line, at_index: 0, length: 1)
      let distance_str =
        string.slice(line, at_index: 1, length: string.length(line) - 1)

      case int.parse(distance_str) {
        Error(_) -> state
        Ok(distance) -> {
          let new_pos_intermediate = case direction {
            "R" -> current_pos + distance
            "L" -> current_pos - distance
            _ -> current_pos
          }

          let new_pos = case int.modulo(new_pos_intermediate, 100) {
            Ok(rem) if rem < 0 -> rem + 100
            Ok(rem) -> rem
            Error(_) -> current_pos
          }

          let new_zero_count = case new_pos == 0 {
            True -> zero_count + 1
            False -> zero_count
          }

          #(new_pos, new_zero_count)
        }
      }
    }
  }
}

fn process_line_part2(state: #(Int, Int), line: String) -> #(Int, Int) {
  case string.is_empty(line) {
    True -> state
    False -> {
      let #(current_pos, zero_count) = state
      let direction = string.slice(line, at_index: 0, length: 1)
      let distance_str =
        string.slice(line, at_index: 1, length: string.length(line) - 1)

      case int.parse(distance_str) {
        Error(_) -> state
        Ok(distance) -> {
          let crossings = case direction {
            "L" -> {
              let a = current_pos - distance + 1
              let b = current_pos - 1
              floor_divide(b, 100) - floor_divide(a - 1, 100)
            }
            "R" -> {
              let a = current_pos + 1
              let b = current_pos + distance - 1
              floor_divide(b, 100) - floor_divide(a - 1, 100)
            }
            _ -> 0
          }

          let new_pos_intermediate = case direction {
            "R" -> current_pos + distance
            "L" -> current_pos - distance
            _ -> current_pos
          }

          let new_pos = case int.modulo(new_pos_intermediate, 100) {
            Ok(rem) if rem < 0 -> rem + 100
            Ok(rem) -> rem
            Error(_) -> current_pos
          }

          let land_on_zero = case new_pos == 0 {
            True -> 1
            False -> 0
          }

          let new_zero_count = zero_count + crossings + land_on_zero

          #(new_pos, new_zero_count)
        }
      }
    }
  }
}

pub fn part1(input: String) -> Int {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  let lines = string.split(normalized_input, on: "\n")
  let initial_state = #(50, 0)
  let final_state = list.fold(lines, initial_state, process_line)
  let #(_, zero_count) = final_state
  zero_count
}

pub fn part2(input: String) -> Int {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  let lines = string.split(normalized_input, on: "\n")
  let initial_state = #(50, 0)
  let final_state = list.fold(lines, initial_state, process_line_part2)
  let #(_, zero_count) = final_state
  zero_count
}
