## args.sh

Provides argument parsing for your bash scripts. Supports parameters arguments (script --file filename.txt), flags (script --force), and positional arguments (script one two).

### Usage

#### Declaration

The script will read these variables to know what arguments to parse.

Currently the variable name are hardcoded as such: "```SCRIPT_NAME```", "```SCRIPT_NAMED_ARGS```", and "```SCRIPT_POSITIONAL_ARGS```"

```
SCRIPT_NAME="build"
SCRIPT_NAMED_ARGS=$'FLAG,r,run,0,\\tRun the built binaries afterwards'
SCRIPT_NAMED_ARGS=$SCRIPT_NAMED_ARGS$'\nPARM,os,os,0,\\tSet the target build OS (GOOS)'
SCRIPT_NAMED_ARGS=$SCRIPT_NAMED_ARGS$'\nPARM,ar,arch,0,Set the target build architecture (GOARCH)'
SCRIPT_NAMED_ARGS=$SCRIPT_NAMED_ARGS$'\nFLAG,d,debug,0,Use this flag to print debug lines'
SCRIPT_POSITIONAL_ARGS=$'PACKAGE_NAMES,List of package names defined in cmd folder\n'
```

```SCRIPT_NAMED_ARGS``` is separated with newlines, where each one is separated with commas (,)
The first data declares wether the arguments is a flag or an parameter.
The second data declares the short-hand CLI argument name for this argument which uses single dash (Example: -f)
The third data declares the full CLI argument name for this argument which uses double dash (Example: --file). This is also used for the exported variable when parsing your arguments.
The fourth data declares wether this argument is required (1) or optional (0).
The fifth data declares the description of the argument.

```SCRIPT_POSITIONAL_ARGS``` also separated with newlines, where each one is separated with commas (,)
The first data declares the variable name to be exported when parsing the arguments.
The second data declares the description of the argument.

#### Parsing

Source the args.sh script after declaring the variables above and the arguments will be exported.

```
. ./args.sh
```