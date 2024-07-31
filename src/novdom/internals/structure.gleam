import filepath
import gleam/result
import glint.{type Command}
import novdom/internals/core/cli.{type Cli}
import novdom/internals/core/cmd
import novdom/internals/core/error.{
  type Error, CannotWriteFile, DependencyInstallationError,
}
import novdom/internals/core/project
import simplifile

pub fn command() -> Command(Nil) {
  let description = "Create project structure"

  use <- glint.command_help(description)
  use <- glint.unnamed_args(glint.EqArgs(0))
  use _, _, flags <- glint.command()

  case cli.run(create(), flags) {
    Ok(_) -> Nil
    Error(error) -> error.explain(error)
  }
}

pub fn create() -> Cli(Nil) {
  use <- cli.log("Creating project structure")

  let root = project.root()
  let outdir = filepath.join(root, "build/.novdom")

  simplifile.create_directory_all(outdir)

  use _ <- cli.do(create_html(outdir, "index_dev.html", html_dev))
  use _ <- cli.do(create_html(outdir, "index.html", html))
  use _ <- cli.do(install_dependencies(root))
  cli.return(Nil)
}

fn create_html(outdir, filename, html) -> Cli(Nil) {
  use <- cli.log("Creating " <> filename)

  let outfile = filepath.join(outdir, filename)

  case check_file_exist(outfile) {
    True -> {
      use <- cli.success(outfile <> " already exist")
      cli.return(Nil)
    }
    False -> {
      let write_result =
        simplifile.write(outfile, html)
        |> result.map_error(CannotWriteFile(_, filepath.join(outdir, outfile)))
      use _ <- cli.try(write_result)
      use <- cli.success(outfile <> " created")
      cli.return(Nil)
    }
  }
}

fn check_file_exist(path) {
  case simplifile.is_file(path) {
    Ok(True) -> True
    Ok(False) | Error(_) -> False
  }
}

fn install_dependencies(root) -> Cli(Nil) {
  use <- cli.log("Installing jsdom")

  let install_dev_result =
    cmd.exec(run: "bun", in: root, with: ["install", "--dev", "jsdom"])
    |> result.map_error(fn(pair) { DependencyInstallationError(pair.1, "bun") })
  use _ <- cli.try(install_dev_result)

  let install_result =
    cmd.exec(run: "bun", in: root, with: ["install", "quill", "tailwind-merge"])
    |> result.map_error(fn(pair) { DependencyInstallationError(pair.1, "bun") })
  use _ <- cli.try(install_result)

  use <- cli.success("jsdom installed")

  cli.return(Nil)
}

const html = "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"./priv/static/iui.css\" />

    <title>🚧 iui</title>

    <!-- Uncomment this if you add the TailwindCSS integration -->
    <!-- <link rel=\"stylesheet\" href=\"/priv/static/iui.css> -->
    <script type=\"module\" src=\"/priv/static/iui.mjs\"></script>
  </head>

  <body>
    <div id=\"_unrendered_\" hidden></div>
    <div id=\"_app_\"></div>
    <div id=\"_drag_\"></div>
  </body>

  <style>
    html,
    body,
    #_app_,
    #_drag_ {
      height: 100%;
      margin: 0;
      padding: 0;
    }
    #_drag_ {
      position: fixed;
      height: 100%;
      width: 100%;
      top: 0;
      left: 0;
      background: transparent;
      pointer-events: none;

      --mouse-x: 0;
      --mouse-y: 0;
    }
  </style>

  <script>
    const drag = document.getElementById(\"_drag_\")

    const mousemove = (e) => {
      drag.style.setProperty(\"--mouse-x\", e.clientX + \"px\")
      drag.style.setProperty(\"--mouse-y\", e.clientY + \"px\")
    }

    document.addEventListener(\"mousemove\", mousemove)
  </script>
</html>
"

const html_dev = "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"./priv/static/iui.css\" />

    <title>🚧 iui</title>

    <!-- Uncomment this if you add the TailwindCSS integration -->
    <!-- <link rel=\"stylesheet\" href=\"/priv/static/iui.css> -->
    <script type=\"module\" src=\"/priv/static/iui.mjs\"></script>
  </head>

  <body>
    <div id=\"_unrendered_\" hidden></div>
    <div id=\"_app_\"></div>
    <div id=\"_drag_\"></div>
  </body>

  <style>
    html,
    body,
    #_app_,
    #_drag_ {
      height: 100%;
      margin: 0;
      padding: 0;
    }
    #_drag_ {
      position: fixed;
      height: 100%;
      width: 100%;
      top: 0;
      left: 0;
      background: transparent;
      pointer-events: none;

      --mouse-x: 0;
      --mouse-y: 0;
    }
  </style>

  <script>
    const drag = document.getElementById(\"_drag_\")

    const mousemove = (e) => {
      drag.style.setProperty(\"--mouse-x\", e.clientX + \"px\")
      drag.style.setProperty(\"--mouse-y\", e.clientY + \"px\")
    }

    document.addEventListener(\"mousemove\", mousemove)
  </script>
</html>
"
