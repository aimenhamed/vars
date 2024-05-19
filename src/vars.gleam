import argv
import envoy
import gleam/dict
import gleam/io
import gleam/result

pub fn main() {
  case argv.load().arguments {
    ["get", ""] -> io.println("Usage: vars get <key>")
    ["get"] -> io.println("Usage: vars get <key>")
    ["get", key] -> get(key)
    ["set", "", _] -> io.println("Usage: vars set <key> <value>")
    ["set", _, ""] -> io.println("Usage: vars set <key> <value>")
    ["set"] -> io.println("Usage: vars set <key> <value>")
    ["set", key, value] -> set(key, value)
    ["unset", ""] -> io.println("Usage: vars unset <key>")
    ["unset"] -> io.println("Usage: vars unset <key>")
    ["unset", key] -> unset(key)
    ["all"] -> get_all()
    ["help"] -> help()
    [] -> help()
    _ -> io.println("Usage: vars help")
  }
}

fn get(key: String) -> Nil {
  let value =
    envoy.get(key)
    |> result.unwrap("")
  io.println(format_pair(key, value))
}

fn set(key: String, value: String) -> Nil {
  envoy.set(key, value)
  io.println("Set: " <> format_pair(key, value))
}

fn unset(key: String) -> Nil {
  envoy.unset(key)
  io.println("Unset: " <> key)
}

fn get_all() -> Nil {
  io.println("Environment variables:")
  envoy.all()
  |> dict.to_list
  |> print_key_value_pairs
}

fn print_key_value_pairs(pairs: List(#(String, String))) -> Nil {
  case pairs {
    [a, ..rest] -> {
      io.println(format_pair(a.0, a.1))
      print_key_value_pairs(rest)
    }
    _ -> Nil
  }
}

fn format_pair(key: String, value: String) -> String {
  key <> "=" <> value
}

fn help() -> Nil {
  io.println("Commands:")
  io.println("  - vars get <key>")
  io.println("  - vars set <key> <value>")
  io.println("  - vars unset <key> <value>")
  io.println("  - vars all")
  io.println("  - vars help")
}
