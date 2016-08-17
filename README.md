# gradle-completion

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)

Basic bash completion for `gradle`.
Task suggestions for your command line.


## Installation

Either

1. Copy the file `gradle_tab_completion.sh` to your `bash_completion`
directory, e.g. `/etc/bash_completion.d`,

2. Or copy the file `gradle_tab_completion.sh` to some location, e.g.
`~/.gradle-completion` and add the following line to your `.bashrc`/`.profile`:
`source ~/.gradle-completion`.

See `Makefile` for details.


## Notes

### Verbosity

The autocompletion gets populated by calling the task `tasks --all`.
Because that usually takes a long time, the completion is cached until one of
the gradle files changes.

### Cache / Storage

The completion is populated on the first call of `gradle` / `gradlew` and will
be cached in `.gradle-tab` local to your current project/directory.

###  Aliases

You can add `gradle` / `gradlew` aliases by adding the following line to your
`.bashrc` / `.profile`: `complete -F _gradlew your_gradlew_alias`.
When using an alias, the script will use `gradlew` in the current
directory or `gradle` if the gradle wrapper cannot be found.
