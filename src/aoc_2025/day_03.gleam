import gleam/int
import gleam/string
import gleam/list
import gleam/order

fn get_max_joltage_for_line(line: String) -> Int {
  let chars = string.to_graphemes(line)
  let length = list.length(chars)
  let indexes = list.range(0, length - 1)

  let pairs = list.flat_map(indexes, fn(i) {
    let rest_indexes = list.filter(indexes, fn(j) { j > i })
    list.map(rest_indexes, fn(j) { #(i, j) })
  })

  let max_joltage = list.fold(pairs, 0, fn(max_joltage, pair) {
    let i = pair.0
    let j = pair.1
    let d1_char = list.drop(chars, i) |> list.first
    let d2_char = list.drop(chars, j) |> list.first

    case d1_char, d2_char {
      Ok(d1_str), Ok(d2_str) -> {
        let num_str = d1_str <> d2_str
        case int.parse(num_str) {
          Ok(joltage) -> {
            int.max(max_joltage, joltage)
          }
          Error(_) -> max_joltage
        }
      }
      _, _ -> max_joltage
    }
  })
  max_joltage
}

pub fn part1(input: String) -> Int {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  let lines = string.split(normalized_input, on: "\n")
  lines
  |> list.map(get_max_joltage_for_line)
  |> int.sum()
}

fn pop_while(stack: List(String), k: Int, digit: String) -> #(List(String), Int) {
  case list.first(stack) {
    Ok(top) if k > 0 -> {
      case string.compare(top, digit) == order.Lt {
        True -> pop_while(list.drop(stack, 1), k - 1, digit)
        False -> #(stack, k)
      }
    }
    _ -> #(stack, k)
  }
}

fn get_largest_12_digit_string(line: String) -> String {
  let digits = string.to_graphemes(line)
  let k_to_remove = list.length(digits) - 12
  
  let #(final_stack_rev, k_left) =
    list.fold(digits, #([], k_to_remove), fn(acc, digit) {
      let #(stack, k) = acc
      let #(new_stack, new_k) = pop_while(stack, k, digit)
      #(list.prepend(new_stack, digit), new_k)
    })

  let final_stack_after_k_drop = list.drop(final_stack_rev, k_left)
  let final_stack = list.reverse(final_stack_after_k_drop)
  
  string.join(final_stack, "")
}

pub fn part2(input: String) -> Int {
  let normalized_input = string.replace(in: input, each: "\r\n", with: "\n")
  let lines = string.split(normalized_input, on: "\n")
  lines
  |> list.map(fn(line) {
    let num_str = get_largest_12_digit_string(line)
    case int.parse(num_str) {
      Ok(n) -> n
      Error(_) -> 0
    }
  })
  |> int.sum()
}



