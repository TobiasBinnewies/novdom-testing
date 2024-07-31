import glint
import glint/constraint

pub fn prod() -> glint.Flag(Bool) {
  let description =
    "Build for production (minify)"

  glint.bool_flag("prod")
  |> glint.flag_help(description)
}