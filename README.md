# gradle-completion

Basic bash completion for ``gradle``.


# Installation:

Either

1. Copy the file ``gradle_tab_completion.sh`` to your ``bash_completion``
directory, e.g. ``/etc/bash_completion.d``,

2. Or copy the file ``gradle_tab_completion.sh`` to some location,
e.g. ``~/.gradle-completion`` and add the following line to your ``.bashrc``
or ``.profile``:

```sh
source ~/.gradle-completion
```


# Notes

The autocompletion gets populated by calling the task ``tasks --all``.
Because that usually takes a long time, the completion is cached until one of
the gradle files changes.

The completion is populated on the first call of ``./gradlew`` and will be
cached in ``.gradle-tab`` local to your current project/directory.

You can add `./gradlew` aliases by adding the following line to your
`.bashrc` / `.profile`: `complete -F _gradlew your_gradlew_alias`


# Known Issues

- ``tasks --all`` can be quite verbose, a switch to change that might be useful
- only the gradle wrapper ``./gradlew`` is officially supported at the moment
