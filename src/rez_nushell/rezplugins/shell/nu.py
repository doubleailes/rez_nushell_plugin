# SPDX-License-Identifier: Apache-2.0
# Copyright Contributors to the Rez Project


"""
Nushell
"""

import os
import re

from rez.shells import Shell
from rez.config import config
from rez.rex import RexExecutor, OutputStyle, EscapedString
from rez.utils.execution import Popen
from rez.utils.platform_ import platform_
from rez.util import shlex_join
from rez.system import system


class Nushell(Shell):
    expand_env_vars = True
    syspaths = None
    ENV_VAR_REGEX = re.compile(
        "|".join(
            [
                r"\\$env\\.[a-zA-Z_][a-zA-Z0-9_]*",  # $env.VAR
                Shell.ENV_VAR_REGEX.pattern,
            ]
        )
    )

    def __test_env_var__(self, var) -> bool:
        return bool(self.ENV_VAR_REGEX.match(var))

    @classmethod
    def name(cls):
        return "nu"

    @classmethod
    def file_extension(cls):
        return "nu"

    @classmethod
    def startup_capabilities(cls, rcfile=False, norc=False, stdin=False, command=False):
        cls._unsupported_option("rcfile", rcfile)
        cls._unsupported_option("norc", norc)
        cls._unsupported_option("stdin", stdin)
        rcfile = False
        norc = False
        stdin = False
        return (rcfile, norc, stdin, command)

    @classmethod
    def get_startup_sequence(cls, rcfile, norc, stdin, command):
        rcfile, norc, stdin, command = cls.startup_capabilities(
            rcfile, norc, stdin, command
        )
        return dict(
            stdin=stdin,
            command=command,
            do_rcfile=False,
            envvar=None,
            files=[],
            bind_files=[],
            source_bind_files=(not norc),
        )

    @classmethod
    def get_syspaths(cls):
        if cls.syspaths is not None:
            return cls.syspaths
        if config.standard_system_paths:
            cls.syspaths = config.standard_system_paths
            return cls.syspaths
        cls.syspaths = os.environ["PATH"].split(os.pathsep)
        return cls.syspaths

    def _bind_interactive_rez(self):
        if config.set_prompt and self.settings.prompt:
            self._addline(f"$env.PROMPT_INDICATOR = '{self.settings.prompt}'")

    def expand_vars(self, values: list[str]):
        """Generate Nushell environment conversion configuration script.

        Creates Nushell ENV_CONVERSIONS settings that handle proper conversion
        of environment variables between string and structured formats. This is
        particularly important for path-like variables that need special handling.

        Args:
            values: List of environment variable names to configure conversions for

        Returns:
            String containing Nushell script for environment variable conversions
        """
        expand_list: list[str] = list()
        self._addline("$env.ENV_CONVERSIONS = {")
        for value in values:
            t = f'    "{value}":'
            t += " {"
            self._addline(t)
            self._addline("        from_string: { |s| $s | split row (char esep) }")
            self._addline(
                "        to_string: { |v| $v | path expand | str join (char esep) }"
            )
            self._addline("    }")
        self._addline("}")

    def _remove_banner(self):
        self._addline("$env.config.show_banner = false")

    def spawn_shell(
        self,
        context_file,
        tmpdir,
        rcfile=None,
        norc=False,
        stdin=False,
        command=None,
        env=None,
        quiet=False,
        pre_command=None,
        add_rez=True,
        **Popen_args,
    ):
        startup_sequence = self.get_startup_sequence(rcfile, norc, stdin, command)
        shell_command = None

        def _record_shell(ex, files, bind_rez=True, print_msg=False):
            ex.source(context_file)
            if startup_sequence["envvar"]:
                ex.unsetenv(startup_sequence["envvar"])
            if add_rez and bind_rez:
                ex.interpreter._bind_interactive_rez()
            if print_msg and add_rez and not quiet:
                ex.info("You are now in a rez-configured environment.")
                if system.is_production_rez_install:
                    ex.command("rezolve context")
            # Add this line to disable the banner
            ex.interpreter._remove_banner()
            # This handle the conversion of environment variables
            ex.interpreter.expand_vars(
                ["PYTHONPATH", "PATH", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"]
            )

        executor = RexExecutor(
            interpreter=self.new_shell(),
            parent_environ={},
            add_default_namespaces=False,
        )

        if startup_sequence["command"] is not None:
            _record_shell(executor, files=startup_sequence["files"])
            shell_command = startup_sequence["command"]
        else:
            _record_shell(
                executor, files=startup_sequence["files"], print_msg=(not quiet)
            )
        code = executor.get_output()
        target_file = os.path.join(tmpdir, f"rez-shell.{self.file_extension()}")
        with open(target_file, "w") as f:
            f.write(code)

        cmd = []
        if pre_command:
            cmd = (
                pre_command
                if isinstance(pre_command, (tuple, list))
                else pre_command.split()
            )
        cmd += [self.executable, "--config", target_file]
        if shell_command:
            cmd.extend(["-c", shell_command])
        return Popen(cmd, env=env, **Popen_args)

    def escape_string(self, value, is_path=False):
        value = EscapedString.promote(value)
        value = value.expanduser()
        result = ""
        for is_literal, txt in value.strings:
            if is_literal:
                txt = txt.replace('"', '\\"').replace("$", "\\$")
            else:
                if is_path:
                    txt = self.normalize_path(txt)
                txt = txt.replace('"', '\\"')
            result += txt
        return f'"{result}"'

    def normalize_path(self, path):
        return path.replace("\\\\", "/") if platform_.name == "windows" else path

    def setenv(self, key, value):
        value = self.escape_string(value, is_path=self._is_pathed_key(key))
        self._addline(f"$env.{key} = {value}")

    def unsetenv(self, key):
        self._addline(f"hide-env {key}")

    def prependenv(self, key, value):
        value = self.escape_string(value, is_path=self._is_pathed_key(key))
        self._addline(f"$env.{key} = ($env.{key} | prepend {value})")

    def appendenv(self, key, value):
        value = self.escape_string(value, is_path=self._is_pathed_key(key))
        self._addline(f"$env.{key} = ($env.{key} | append {value})")

    def resetenv(self, key, value, friends=None):
        self.setenv(key, value)

    def alias(self, key, value):
        self._addline(f"alias {key} = {value}")

    def comment(self, value):
        for line in value.split("\\n"):
            self._addline(f"# {line}")

    def info(self, value):
        for line in value.split("\\n"):
            self._addline(f"print {self.escape_string(line)}")

    def error(self, value):
        for line in value.split("\\n"):
            self._addline(f"error make {self.escape_string(line)}")

    def source(self, value):
        self._addline(f"source {self.escape_string(value)}")

    def command(self, value):
        self._addline(value)

    @classmethod
    def get_all_key_tokens(cls, key):
        return [f"$env.{key}"]

    def shebang(self):
        self._addline("#!%s" % self.executable)

    @classmethod
    def line_terminator(cls):
        return "\n"

    @classmethod
    def join(cls, command):
        return shlex_join(command)


def register_plugin():
    return Nushell
