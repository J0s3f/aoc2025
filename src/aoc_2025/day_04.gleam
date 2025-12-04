import gleam/list
import gleam/string
import gleam/int
import iv

type Cell {
  Roll
  Empty
}

fn parse_grid(input: String) -> iv.Array(iv.Array(Cell)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.to_graphemes
    |> list.map(fn(char) {
      case char {
        "@" -> Roll
        _ -> Empty
      }
    })
    |> iv.from_list
  })
  |> iv.from_list
}

fn get_cell(grid: iv.Array(iv.Array(Cell)), x: Int, y: Int) -> Cell {
  case iv.get(grid, y) {
    Ok(row) -> {
      case iv.get(row, x) {
        Ok(cell) -> cell
        Error(Nil) -> Empty
      }
    }
    Error(Nil) -> Empty
  }
}

fn count_neighbor_rolls(grid: iv.Array(iv.Array(Cell)), x: Int, y: Int) -> Int {
  let dx = [-1, 0, 1, -1, 1, -1, 0, 1]
  let dy = [-1, -1, -1, 0, 0, 1, 1, 1]

  list.fold(
    list.zip(dx, dy),
    0,
    fn(acc, coords) {
      let #(cx, cy) = coords
      let neighbor_x = x + cx
      let neighbor_y = y + cy

      case get_cell(grid, neighbor_x, neighbor_y) {
        Roll -> acc + 1
        Empty -> acc
      }
    },
  )
}

pub fn part1(input: String) -> Int {
  let grid = parse_grid(input)
  let #(_, count) = step_grid(grid)
  count
}

fn step_grid(grid: iv.Array(iv.Array(Cell))) -> #(iv.Array(iv.Array(Cell)), Int) {
  let height = iv.length(grid)
  let width = case iv.get(grid, 0) {
    Ok(row) -> iv.length(row)
    Error(_) -> 0
  }

  let #(new_grid_list, row_counts) =
    list.map(list.range(0, height - 1), fn(y) {
      let #(new_row_list, cell_counts) =
        list.map(list.range(0, width - 1), fn(x) {
          let current_cell = get_cell(grid, x, y)
          case current_cell {
            Roll -> {
              case count_neighbor_rolls(grid, x, y) < 4 {
                True -> #(Empty, 1)
                False -> #(Roll, 0)
              }
            }
            Empty -> #(Empty, 0)
          }
        })
        |> list.unzip

      #(iv.from_list(new_row_list), int.sum(cell_counts))
    })
    |> list.unzip

  #(iv.from_list(new_grid_list), int.sum(row_counts))
}

fn solve_part2(grid: iv.Array(iv.Array(Cell)), total_removed: Int) -> Int {
  let #(new_grid, removed_count) = step_grid(grid)
  case removed_count {
    0 -> total_removed
    _ -> solve_part2(new_grid, total_removed + removed_count)
  }
}

pub fn part2(input: String) -> Int {
  let grid = parse_grid(input)
  solve_part2(grid, 0)
}
