from rez.shells import Shell
import re


class Nushell(Shell):
    ENV_VAR_REGEX = re.compile(
        "|".join(
            [
                "\$env\.[a-zA-Z_][a-zA-Z0-9_]*",  # $Env:ENVVAR
                Shell.ENV_VAR_REGEX.pattern,  # Generic form
            ]
        )
    )

    def __test_env_var__(self, var) -> bool:
        """
        Test if the variable is a valid Nushell environment variable.
        """
        return bool(self.ENV_VAR_REGEX.match(var))

    @classmethod
    def name(cls) -> str:
        """
        Return the name of the shell.
        """
        return "nu"

    @classmethod
    def file_extension(cls) -> str:
        """
        Return the file extension for the shell.
        """
        return "nu"

    def setenv(self, key, value):
        """
        Set an environment variable in Nushell.
        """
        value = self.escape_string(value, is_path=self._is_pathed_key(key))
        self._addline(f"$env.{key}={value}")

    def unsetenv(self, key):
        """
        Unset an environment variable in Nushell.
        """
        self._addline(f"hide-env {key}")

    def prependenv(self, key, value):
        """
        Prepend a value to an environment variable in Nushell.
        """
        self._addline(f"$env.{key} = ($env.{key} | prepend \"{value}\"")

    def appendenv(self, key, value):
        """
        Append a value to an environment variable in Nushell.
        """
        self._addline(f"$env.{key} = ($env.{key} | append \"{value}\")")

    def alias(self, key, value):
        """
        Create an alias in Nushell.
        """
        self._addline(f"alias {key} = {value}")

    @classmethod
    def startup_capabilities(cls, rcfile=False, norc=False, stdin=False, command=False):
        """
        Given a set of options related to shell startup, return the actual
        options that will be applied.

        Returns:
            tuple: 4-tuple representing applied value of each option.
        """
