from rez_nushell.rezplugins.shell.nu import Nushell

def test_env_var_regex():
    # Test the regex pattern for valid Nushell environment variables
    assert Nushell.ENV_VAR_REGEX.match("$env.VAR_NAME")
    assert Nushell.ENV_VAR_REGEX.match("$env.VAR_123")
    assert Nushell.ENV_VAR_REGEX.match("$env._VAR")
    assert Nushell.ENV_VAR_REGEX.match("$env.")
    assert Nushell.ENV_VAR_REGEX.match("$env.123")
    assert Nushell.ENV_VAR_REGEX.match("$env.VAR-NAME")
    assert not Nushell.ENV_VAR_REGEX.match("VAR_NAME")
    assert not Nushell.ENV_VAR_REGEX.match("env.VAR_NAME")

def test_name():
    # Test the name of the shell
    assert Nushell.name() == "nu"

def test_file_extension():
    # Test the file extension for the shell
    assert Nushell.file_extension() == "nu"

def test_startup_capabilities():
    # Test the startup capabilities of the shell
    rcfile, norc, stdin, command = Nushell.startup_capabilities(rcfile=True, norc=True, stdin=True, command=True)
    assert rcfile is False
    assert norc is False
    assert stdin is False
    assert command is True
    assert Nushell.startup_capabilities() == (False, False, False, False)

def test_expand_vars(monkeypatch):
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
    shell = DummyNushell()
    shell._expand_vars(["FOO", "BAR"])
    assert lines[0] == "$env.ENV_CONVERSIONS = {"
    assert any('"FOO":' in l for l in lines)
    assert any('"BAR":' in l for l in lines)
    assert lines[-1] == "}"

def test_normalize_path_windows(monkeypatch):
    class MockPlatform:
        name = "windows"
    monkeypatch.setattr("rez_nushell.rezplugins.shell.nu.platform_", MockPlatform)
    shell = Nushell()
    assert shell.normalize_path("C:/foo/bar") == "C:\\foo\\bar"

def test_normalize_path_linux(monkeypatch):
    monkeypatch.setattr("rez.utils.platform_.platform_.name", "linux")
    shell = Nushell()
    assert shell.normalize_path("/foo/bar") == "/foo/bar"

def test_setenv_and_unsetenv():
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
        def _is_pathed_key(self, key):
            return False
        def escape_string(self, value, is_path=False):
            return f'"{value}"'
    shell = DummyNushell()
    shell.setenv("FOO", "bar")
    shell.unsetenv("FOO")
    assert lines[0] == "$env.FOO = \"bar\""
    assert lines[1] == "hide-env FOO"

def test_prependenv_and_appendenv():
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
        def _is_pathed_key(self, key):
            return False
        def escape_string(self, value, is_path=False):
            return f'"{value}"'
    shell = DummyNushell()
    shell.prependenv("FOO", "bar")
    shell.appendenv("FOO", "baz")
    assert lines[0] == "$env.FOO = ($env.FOO | prepend \"bar\")"
    assert lines[1] == "$env.FOO = ($env.FOO | append \"baz\")"

def test_join():
    assert Nushell.join(["echo", "hello world"]) == 'echo "hello world"'

def test_bind_interactive_rez(monkeypatch):
    lines = []
    class DummyConfig:
        set_prompt = True
    class DummySettings:
        prompt = "PROMPT> "
    class DummyNushell(Nushell):
        def __init__(self):
            self.settings = DummySettings()
        def _addline(self, line):
            lines.append(line)
    monkeypatch.setattr("rez.config.config", DummyConfig)
    shell = DummyNushell()
    shell._bind_interactive_rez()
    assert lines[0] == "$env.PROMPT_INDICATOR = 'PROMPT> '"

def test_remove_banner():
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
    shell = DummyNushell()
    shell._remove_banner()
    assert lines[0] == "$env.config.show_banner = false"

def test_info_and_error():
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
        def escape_string(self, value, is_path=False):
            return f'"{value}"'
    shell = DummyNushell()
    shell.info("hello")
    shell.error("fail")
    assert lines[0] == 'print "hello"'
    assert lines[1] == 'error make "fail"'

def test_alias():
    lines = []
    class DummyNushell(Nushell):
        def _addline(self, line):
            lines.append(line)
    shell = DummyNushell()
    shell.alias("ll", "ls -l")
    assert lines[0] == "alias ll = ls -l"

def test_shebang():
    lines = []
    class DummyNushell(Nushell):
        executable = "/usr/bin/nu"
        def _addline(self, line):
            lines.append(line)
    shell = DummyNushell()
    shell.shebang()
    assert lines[0] == "#!/usr/bin/nu"

def test_env_var_regex_match():
    assert Nushell.ENV_VAR_REGEX.match("$env.PATH")
    assert Nushell.ENV_VAR_REGEX.match("$env._MYVAR")
    assert not Nushell.ENV_VAR_REGEX.match("PATH")