import argv
import gleam/io
import glint
import novdom/internals/structure
import novdom/internals/build

pub fn main() {
  let args = argv.load().arguments

  glint.new()
  |> glint.as_module
  |> glint.with_name("dev_tools/dev")
  |> glint.add(at: ["init"], do: structure.command())
  |> glint.add(at: ["build"], do: build.command())
  |> glint.run(args)
}
