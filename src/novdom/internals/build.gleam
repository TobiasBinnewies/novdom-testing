import glint.{type Command}
import novdom/internals/core/project
import novdom/internals/core/flag
import novdom/internals/core/cli.{type Cli}
import novdom/internals/core/error.{type Error}
import novdom/internals/structure
import gleam/io

pub fn command() -> Command(Nil) {
    let description = "Build and bundle project"

    use <- glint.command_help(description)
    use <- glint.unnamed_args(glint.EqArgs(0))
    use prod <- glint.flag(flag.prod())
    use _, _, flags <- glint.command()

    let script = {
        use prod <- cli.do(cli.get_bool("prod", False, ["build"], prod))
        
        build(prod)
    }

    case cli.run(script, flags) {
        Ok(_) -> Nil
        Error(error) -> error.explain(error)
    }
}

pub fn build(prod: Bool) -> Cli(Nil) {
    use <- cli.log("Building project")

    use _ <- cli.do(structure.create())
    
    use _ <- cli.try(project.build())

    cli.return(Nil)
}