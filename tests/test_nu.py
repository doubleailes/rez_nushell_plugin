from rez_nushell.rez_plugins.shell.nu import Nushell

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