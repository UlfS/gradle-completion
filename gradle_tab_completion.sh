#!/bin/bash

DIR=".gradle-tab"
LAST_MOD_FILE="$DIR/last_modified"
CACHE_FILE="$DIR/cache"


# XXX: unused
# get last modification time of all gradle files
function __gradlew_lastModified() {
  find . -type f -iname '*.gradle' -print0 | xargs -0 stat -c %Y | sort | tail -n 1
}

function __gradlew_hash() {
  find . -type f -iname '*.gradle' -print0 | xargs -0 cat | md5sum
}

# 1: timestamp/hash to save
function __gradlew_saveCacheIndicator() {
  [ ! -d "$DIR" ] && mkdir "$DIR"
  echo "$@" > "$LAST_MOD_FILE"
}

# 1: list of tab completions to save
function __gradlew_saveCache() {
  [ ! -d "$DIR" ] && mkdir "$DIR"
  echo "$@" > "$CACHE_FILE"
}

function __gradlew_loadCache() {
  [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE"
}

# XXX: unused
function __gradlew_lastModifiedCached() {
  [ -f "$LAST_MOD_FILE" ] && cat "$LAST_MOD_FILE" || echo 0
}

function __gradlew_hashCached() {
  [ -f "$LAST_MOD_FILE" ] && cat "$LAST_MOD_FILE" || echo "never-hashed-before"
}

function __gradlew_completions() {
  local hashed=$(__gradlew_hash)
  local hashed_cache=$(__gradlew_hashCached)
  if [ "$hashed" != "$hashed_cache" ]
  then
    __gradlew_refreshCache "$1"
    __gradlew_saveCacheIndicator "$hashed"
  fi
  __gradlew_loadCache
}

function __gradlew_refreshCache() {
  local tasks=$($1 --quiet tasks --all --console plain | grep '[[:space:]]*[[:alnum:]]\+ - ' | awk '{print $1}' | tr '\n' ' ')
  if [ $? -eq 0 -a -n "$tasks" ]
  then
    __gradlew_saveCache "$tasks"
  fi
}

function __gradlew_guess_gradle_command() {
  if which "$1" 1>/dev/null ;then
    echo "$1"
  elif [ -x "./gradlew" ] ;then
    echo "./gradlew"
  elif which "gradle" 1>/dev/null ;then
    echo "gradle"
  else
    # cannot find gradle/gradlew
    return 1
  fi

  return 0
}

_gradlew() {
  local gradle
  gradle_command=$(__gradlew_guess_gradle_command "$1")

  if [ $? -ne 0 ]; then
    return 1
  fi

  local cur=${COMP_WORDS[COMP_CWORD]}
  _get_comp_words_by_ref -n : cur
  tasks=$(__gradlew_completions "$gradle_command")
  COMPREPLY=( $(compgen -W "$tasks" -- "$cur") )

  __ltrim_colon_completions "$cur"
}

complete -F _gradlew ./gradlew
complete -F _gradlew gradle
