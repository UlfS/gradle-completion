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
  else
    __gradlew_loadCache
  fi
}

function __gradlew_refreshCache() {
  local tasks=$($1 --quiet tasks --all | grep ' - ' | awk '{print $1}' | tr '\n' ' ')
  if [ -n "$tasks" ]
  then
    echo "$tasks"
    __gradlew_saveCache "$tasks"
  fi
}

_gradlew() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  _get_comp_words_by_ref -n : cur
  tasks=$(__gradlew_completions "$1")
  COMPREPLY=( $(compgen -W "$tasks" -- "$cur") )

  __ltrim_colon_completions "$cur"
}

complete -F _gradlew ./gradlew
complete -F _gradlew gradle
