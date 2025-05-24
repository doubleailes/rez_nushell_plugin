# Rez Nushell Plugin

This project is a plugin for the [Rez](https://github.com/AcademySoftwareFoundation/rez)
package management system, enabling integration with [Nushell](https://www.nushell.sh/)
, a modern shell designed for structured data.

## Features

- Provides support for using **Rez** with **Nushell**.
- Implements environment variable handling specific to **Nushell**.
- **Nushell** completion support for Rez commands.

The plugin is feature-complete with **PowerShellBase**, even though it doesn't
inherit from that class.

## Requirements

- Python >= 3.9
- Rez >= 3.2.1
- Nushell >= 0.96

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/doubleailes/rez_nushell_plugin.git
   ```

2. Set the plugin path:

   Set the `REZ_PLUGIN_PATH` environment variable to include the path to this plugin.
   You can do this by adding the following line to your shell configuration file.
   The path should point to the `rez_nushell` directory in the cloned repository.

   ```nushell
   $env.REZ_PLUGIN_PATH = '<PATHOFTHEREPOSITORY>/src/rez_nushell/'
   ```

3. Optional:
   You can add autocompletion for Rez commands in **Nushell** by adding the following line
   to your **Nushell** configuration file:

   ```nushell
   source <PATHOFTHEREPOSITORY>/rez-completions.nu
   ```

## Usage

Once set, you can use Rez with **Nushell** by specifying `nu` as the shell type. For example:

```bash
rez-env my_package -- shell nu
```

Or simply use rez commands as you would in any other shell in a Nushell session.

## Development

To contribute to this project:

1. Fork the repository and create a new branch for your feature or bugfix.
2. Make your changes and ensure they are well-tested.
3. Submit a pull request with a detailed description of your changes.

## License

This project is licensed under the MIT. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

This plugin is inspired by the **Rez** project and aims to extend its functionality to support modern shells like Nushell.
