from rez.shells import Shell
import re

class Nushell(Shell):
    ENV_VAR_REGEX = re.compile(
        "|".join([
            "\$env\.[a-zA-Z_][a-zA-Z0-9_]*",       # $Env:ENVVAR
            Shell.ENV_VAR_REGEX.pattern,               # Generic form
        ])
    )