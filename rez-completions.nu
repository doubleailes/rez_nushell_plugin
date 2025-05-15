export extern "rez bind" [
  --quickstart                                      # bind a set of standard packages to get started
  --release(-r)                                     # install to release path; overrides -i
  --install-path(-i): path                          # install path, defaults to local package path
  --no-deps                                         # do not bind dependencies
  --list(-l)                                        # list all available bind modules
  --search(-s)                                      # search for the bind module but do not perform the bind
  --verbose(-v)                                     # verbose mode, repeat for more verbosity
]

export extern "rez build" [
  --clean(-c)                                      # clear the current build before rebuilding
  --install(-i)                                    # install the build to the local packages path
  --prefix(-p): path                               # install to a custom package repository path
  --fail-graph                                     # display the resolve graph as an image on failure
  --scripts(-s)                                    # create build scripts instead of running the full build
  --view-pre                                       # view the preprocessed package definition and exit
  --process: string                                # build process to use (local or remote)
  --build-system(-b): string                       # specify the build system to use
  --variants: list<int>                            # select variants to build (zero-indexed)
  --build-args: string                       # arguments for the build system
  --ba : string                                    # arguments for the build system
  --child-build-args: string                # arguments for the child build system
  --cba : string                                   # arguments for the child build system
  --verbose(-v)                                    # verbose mode, repeat for more verbosity
]

export extern "rez config" [
  field?: string                                   # print the value of a specific setting
  --json                                           # output dict/list values as JSON (ignored if no field)
  --search-list                                    # list the config files searched
  --source-list                                    # list the config files sourced
  --verbose(-v)                                    # verbose mode, repeat for more verbosity
]

export extern "rez context" [
  rxt?: string                                         # rez context file (or "-" for stdin)
  --print-request                                     # print only the request list (not including implicits)
  --req                                               # print only the request list (not including implicits)
  --print-resolve                                     # print only the resolve list
  --res                                               # print only the resolve list
  --source-order                                      # print packages in resolved order
  --so                                                # print packages in resolved order
  --show-uris                                         # list package URIs instead of root filepaths
  --su                                                # list package URIs instead of root filepaths
  --tools(-t)                                         # print list of executables in the context
  --which: string                                     # locate a program within the context
  --graph(-g)                                         # display the resolve graph as an image
  --dependency-graph(-d)                              # show the simpler dependency graph
  --print-graph                                       # print the resolve graph as a string
  --pg                                                # print the resolve graph as a string
  --write-graph: path                                 # write the resolve graph to a file
  --wg :path                                          # write the resolve graph to a file
  --prune-package: string                             # prune the graph down to a given package
  --pp : string                                       # prune the graph down to a given package
  --interpret(-i)                                     # interpret the context and print the resulting code
  --format(-f): string                                # format to use for interpreted output
  --style(-s): string                                 # code output style (file or eval)
  --no-env                                            # interpret in an empty environment
  --diff: string                                      # diff current context against another
  --fetch                                             # diff against a re-resolved version of current context
  --verbose(-v)                                       # verbose mode, repeat for more verbosity
]

export extern "rez cp" [
  pkg?: string                                        # package to copy
  --dest-path: path                                   # destination repository path
  --paths: path                                       # set package search path
  --no-local                                          # don't search local packages
  --nl                                                # don't search local packages
  --reversion: string                                 # copy to a different version
  --rename: string                                    # copy to a different name
  --overwrite(-o)                                     # overwrite existing package/variants
  --shallow(-s)                                       # perform a shallow copy (symlink top-level dirs)
  --follow-symlinks                                   # follow symlinks when copying payload
  --keep-timestamp(-k)                                # keep timestamp of source package
  --force(-f)                                         # copy even if not relocatable
  --allow-empty                                       # allow copy into empty target repo
  --dry-run                                           # simulate the copy without making changes
  --variants: list<int>                               # select variants to copy
  --variant-uri: string                               # copy variant by URI
  --verbose(-v)                                       # verbose mode
]

export extern "rez depends" [
  pkg: string                                           # package that other packages depend on
  --depth(-d): int                                      # dependency tree depth limit
  --paths: path                                         # set package search path
  --build-requires(-b)                                  # include build requirements
  --private-build-requires(-p)                          # include private build requirements
  --graph(-g)                                           # display the dependency tree as an image
  --print-graph                                         # print the dependency tree as a string
  --pg                                                  # print the dependency tree as a string
  --write-graph: path                                   # write the dependency tree to a file
  --wg: path                                            # write the dependency tree to a file
  --quiet(-q)                                           # suppress progress bar and depth indicators
  --verbose(-v)                                         # verbose mode
]

export extern "rez diff" [
  pkg1: string                                         # package to diff
  pkg2?: string                                        # package to diff against (optional)
  --verbose(-v)                                        # verbose mode
]

export extern "rez env" [
  ...pkg: string                                         # packages to use in the target environment
  --shell: string                                        # target shell type (default: nu)
  --rcfile: path                                         # source this file instead of standard shell startup scripts
  --norc                                                 # skip loading startup scripts
  --command(-c): string                                  # execute command within rez env and exit
  --stdin(-s)                                            # read commands from standard input
  --no-implicit                                          # don't add implicit packages
  --ni                                                   # don't add implicit packages
  --no-local                                             # don't load local packages
  --nl                                                   # don't load local packages
  --build(-b)                                            # create a build environment
  --paths: path                                          # set package search path (use ':' separator)
  --time(-t): string                                     # ignore packages released after a given time
  --max-fails: int                                       # abort if failed config attempts exceed this
  --time-limit: int                                      # abort if resolve time exceeds this many seconds
  --output(-o): path                                     # store the context into an .rxt file or stdout
  --input(-i): path                                      # use a previously saved context file
  --exclude: list<string>                                # package exclusion filters
  --include: list<string>                                # package inclusion filters
  --no-filters                                           # disable global filters
  --patch(-p)                                            # patch the current context
  --strict                                               # strict patching (only with --patch)
  --patch-rank: int                                      # patch rank (only with --patch)
  --no-cache                                             # don't fetch cached resolves
  --quiet(-q)                                            # suppress welcome message
  --fail-graph                                           # show resolve graph image on failure
  --new-session                                          # start in a new process group
  --detached                                             # open a separate terminal
  --no-passive                                           # print only active solver actions (with verbosity)
  --stats                                                # print advanced solver stats
  --no-pkg-cache                                         # disable package caching
  --pkg-cache-mode: string                               # override package_cache_async (sync/async)
  --verbose(-v)                                          # verbose mode
]

export extern "rez gui" [
  ...file: path                                         # context files to open in the GUI
  --diff: list<path>                                    # open in diff mode with two context files
  --verbose(-v)                                         # verbose mode
]

export extern "rez help" [
  PACKAGE?: string                                     # package name to show help for
  SECTION?: int                                        # help section to view (1..N)
  --manual(-m)                                         # load the rez technical user manual
  --entries(-e)                                        # print each help entry
  --verbose(-v)                                        # verbose mode
]

export extern "rez interpret" [
  FILE: path                                              # file containing rex code to execute
  --format(-f): string                                    # output format (default: nu)
  --no-env                                                # interpret in an empty environment
  --parent-variables: list<string>                        # environment variables to update on first reference
  --pv: list<string>                                      # same as --parent-variables
  --verbose(-v)                                           # verbose mode
]

export extern "rez memcache" [
  --flush                                              # flush all cache entries
  --stats                                              # list stats
  --reset-stats                                        # reset statistics
  --poll                                               # continually poll, showing get/sets per second
  --interval: float                                    # polling interval in seconds (default: 1.0)
  --warm                                               # warm the cache with visible packages
  --verbose(-v)                                        # verbose mode
]

export extern "rez pip" [
  PACKAGE: string                                         # package name, archive, or URL to install
  --python-version: string                                # Python version (rez package) to use
  --install(-i)                                           # install the package
  --release(-r)                                           # install as a released package
  --prefix(-p): path                                      # custom package repository path
  --extra(-e): list<string>                               # extra arguments to pass to pip install
  --verbose(-v)                                           # verbose mode
]

export extern "rez pkg-cache" [
  dir?: path                                               # package cache directory (defaults to config)
  --add-variants(-a): list<string>                         # add variants to the cache
  --logs                                                   # view logs
  --remove-variants(-r): list<string>                      # remove variants from cache
  --clean                                                  # remove unused variants and pending deletions
  --pkg-cache-mode: string                                 # override rezconfig's package_cache_async setting
  --columns(-c): list<string>                              # columns to print
  --force(-f)                                              # force cache add (only with --add-variants)
  --verbose(-v)                                            # verbose mode
]

export extern "rez plugins" [
  PKG: string                                        # package to list plugins for
  --paths: path                                      # set package search path
  --verbose(-v)                                      # verbose mode
]

export extern "rez python" [
  file?: path                                        # Python script to execute
  --verbose(-v)                                      # verbose mode
]

export extern "rez release" [
  --message(-m): string                                  # release message
  --vcs: string                                          # force the VCS type to use
  --no-latest                                            # allow release of version earlier than the latest
  --ignore-existing-tag                                  # proceed even if current version is already tagged
  --skip-repo-errors                                     # ignore repository-related errors during release
  --no-message                                           # do not prompt for a release message
  --process: string                                      # build process to use (local or remote)
  --build-system(-b): string                             # specify the build system
  --variants: list<int>                                  # select variants to build
  --build-args: string                                   # arguments for the build system
  --ba: string                                           # arguments for the build system
  --child-build-args: string                             # arguments for the child build system
  --cba: string                                          # arguments for the child build system
  --verbose(-v)                                          # verbose mode
]

export extern "rez selftest" [
  --only-shell(-s): string                               # limit shell-dependent tests to specified shell
  --keep-tmpdirs                                         # keep temporary directories
  --bind                                                 # test package_bind module
  --build                                                # test the build system
  --cli                                                  # test CLI tools
  --commands                                             # test package commands
  --completion                                           # test completions
  --config                                               # test configuration settings
  --context                                              # test resolved contexts
  --copy_package                                         # test package copying
  --formatter                                            # test rex string formatting
  --imports                                              # test importing of all source
  --package_cache                                        # test package caching
  --package_filter                                       # test package filtering
  --packages                                             # test package iteration, serialization etc
  --packages_order                                       # test package ordering logic
  --pip_utils                                            # test pip utilities
  --plugin_manager                                       # test rez plugin manager behaviors
  --release                                              # test the release system
  --resources_                                           # test core resource system
  --rex                                                  # test rex command generation
  --schema                                               # test schema module
  --shells                                               # test shell invocation
  --solver                                               # test dependency resolving
  --suites                                               # test suite system
  --test                                                 # test `rez.package.py` unit tests
  --util                                                 # unit tests for 'util' module
  --utils                                                # unit tests for 'utils.filesystem'
  --utils_elf                                            # unit tests for 'rez.utils.elf'
  --utils_filesystem                                     # unit tests for 'rez.utils.filesystem'
  --utils_formatting                                     # unit tests for 'utils.formatting'
  --utils_resolve_graph                                  # unit tests for 'utils.resolve_graph'
  --version                                              # unit tests for 'rez.version' module
  --verbose(-v)                                          # verbose mode
]

export extern "rez status" [
  object?: string                                     # object to query (tool, package, context, suite)
  --tools(-t)                                         # list visible tools (OBJECT can be a glob)
  --verbose(-v)                                       # verbose mode
]

export extern "rez suite" [
  dir?: path                                             # directory of the suite to manage or create
  --list(-l)                                             # list visible suites
  --tools(-t)                                            # list tools in the suite
  --which: string                                        # print the path to a tool in the suite
  --validate                                             # validate the suite
  --create                                               # create an empty suite at DIR
  --context(-c): string                                  # specify context name (used with context-specific options)
  --interactive(-i)                                      # enter an interactive shell in the given context
  --add(-a): path                                        # add a context to the suite (RXT file)
  --prefix-char(-P): string                              # character to access rez options (used with --add)
  --remove(-r): string                                   # remove a context from the suite by name
  --description(-d): string                              # set context description
  --prefix(-p): string                                   # set prefix for a context
  --suffix(-s): string                                   # set suffix for a context
  --hide: string                                         # hide a tool from the suite
  --unhide: string                                       # unhide a tool in the suite
  --alias: list<string>                                  # create an alias (TOOL ALIAS)
  --unalias: string                                      # remove an alias
  --bump(-b): string                                     # prioritize a context's tools
  --find-request: string                                 # find contexts requesting a package
  --find-resolve: string                                 # find contexts resolving a package
  --verbose(-v)                                          # verbose mode
]

export extern "rez test" [
  PKG: string                                             # package to run tests on
  ...test: string                                         # specific test(s) to run (optional)
  --list(-l)                                              # list package's tests and exit
  --dry-run                                               # show what would be run without executing
  --stop-on-fail(-s)                                      # stop on first test failure
  --inplace                                               # run tests in the current environment
  --extra-packages: list<string>                          # additional packages to include in test env
  --paths: path                                           # package search path
  --no-local                                              # don't load local packages
  --nl                                                    # don't load local packages
  --verbose(-v)                                           # verbose mode
]

export extern "rez view" [
  PKG: string                                             # the package to view
  --format(-f): string                                    # output format: py or yaml
  --all(-a)                                               # show all package data
  --brief(-b)                                             # hide extraneous info (e.g. package URI)
  --current(-c)                                           # show package in the current context
  --verbose(-v)                                           # verbose mode
]

export extern "rez yaml2py" [
  path?: path                                           # path to yaml file or directory (defaults to cwd)
  --verbose(-v)                                         # verbose mode
]

export extern "rez bundle" [
  RXT: string                                            # context to bundle
  DEST_DIRT: path                                         # destination directory (must not exist)
  --skip-non-relocatable(-s)                             # skip non-relocatable packages instead of erroring
  --force(-f)                                            # force bundling even if not relocatable
  --no-lib-patch(-n)                                     # do not apply library patching
  --verbose(-v)                                          # verbose mode
]

export extern "rez benchmark" [
  --out: path                                             # output directory for benchmark results
  --iterations: int                                       # number of times to run each resolve (default: 1)
  --histogram                                             # show an ASCII histogram of resolve times
  --compare: path                                         # compare results from another benchmark output
  --verbose(-v)                                           # verbose mode
]

export extern "rez pkg-ignore" [
  pkg: string                                             # package to (un)ignore (e.g. foo-1.2.3)
  path?: path                                             # repository path; optional (interactive prompt if omitted)
  --unignore(-u)                                          # unignore the specified package
  --allow-missing(-a)                                     # allow ignoring non-existent packages
  --verbose(-v)                                           # verbose mode
]

export extern "rez mv" [
  pkg: string                                             # package to move (e.g. 'foo-1.2.3')
  path?: path                                             # repository containing the package
  --dest-path(-d): path                                   # destination repository path
  --keep-timestamp(-k)                                    # keep timestamp of source package
  --force(-f)                                             # move even if not relocatable
  --verbose(-v)                                           # verbose mode
]

export extern "rez rm" [
  path?: path                                             # repository path containing package(s) or families
  --package(-p): string                                   # remove a specific package (e.g. 'foo-1.2.3')
  --family(-f): string                                    # remove an entire package family (only if empty)
  --force-family                                          # remove family even if not empty (use with caution)
  --ignored-since(-i): int                                # remove packages ignored for >= DAYS
  --dry-run                                               # simulate the removal without deleting
  --verbose(-v)                                           # verbose mode
]

