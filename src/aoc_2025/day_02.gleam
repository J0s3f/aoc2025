import gleam/int
import gleam/list
import gleam/string

type Range {
  Range(start: Int, end: Int)
}

fn parse_ranges(input: String) -> List(Range) {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  string.split(normalized_input, on: ",")
  |> list.filter_map(fn(range_str) {
    case string.split(range_str, on: "-") {
      [start_str, end_str] -> {
        case int.parse(start_str), int.parse(end_str) {
          Ok(start_id), Ok(end_id) -> Ok(Range(start_id, end_id))
          _, _ -> Error(Nil)
        }
      }
      _ -> Error(Nil)
    }
  })
}

fn is_invalid_id_part1(id: Int) -> Bool {
  let s = int.to_string(id)
  let len = string.length(s)
  case len > 0 && len % 2 == 0 {
    True -> {
      let half_len = len / 2
      string.slice(s, 0, half_len) == string.slice(s, half_len, half_len)
    }
    False -> False
  }
}

pub fn is_invalid_id_part2(id: Int) -> Bool {
  let s = int.to_string(id)
  let len = string.length(s)
  case len < 2 {
    True -> False
    False ->
      list.range(1, len / 2)
      |> list.any(fn(l) {
        case len % l == 0 {
          False -> False
          True -> {
            let base = string.slice(s, 0, l)
            let num_repetitions = len / l
            string.repeat(base, num_repetitions) == s
          }
        }
      })
  }
}

pub fn part2_get_invalid_ids(input: String) -> List(Int) {
  let ranges = parse_ranges(input)
  list.fold(ranges, [], fn(acc, range) {
    let ids_in_range =
      list.filter(list.range(range.start, range.end), fn(id) {
        is_invalid_id_part2(id)
      })
    list.append(acc, ids_in_range)
  })
}

pub fn part1(input: String) -> Int {
  let ranges = parse_ranges(input)
  list.fold(ranges, 0, fn(acc, range) {
    acc
    + list.fold(list.range(range.start, range.end), 0, fn(sum, id) {
      case is_invalid_id_part1(id) {
        True -> sum + id
        False -> sum
      }
    })
  })
}

pub fn part2(input: String) -> Int {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  let range_strings = string.split(normalized_input, on: ",")

  list.fold(range_strings, 0, fn(acc, range_str) {
    let trimmed_range_str = string.trim(range_str)
    let parts = string.split(trimmed_range_str, on: "-")
    case parts {
      [start_str, end_str] -> {
        case int.parse(start_str), int.parse(end_str) {
          Ok(start_id), Ok(end_id) -> {
            let invalid_ids_in_range =
              list.fold(list.range(start_id, end_id), 0, fn(current_sum, id) {
                case is_invalid_id_part2(id) {
                  True -> current_sum + id
                  False -> current_sum
                }
              })
            acc + invalid_ids_in_range
          }
          _, _ -> acc
          // parse problem
        }
      }
      _ -> acc
    }
  })
}
