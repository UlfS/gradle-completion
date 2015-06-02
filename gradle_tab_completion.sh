#!/bin/bash

DIR=".gradle-tab"
LAST_MOD_FILE="$DIR/last_modified"
CACHE_FILE="$DIR/cache"


# get last modification time of all gradle filex
function __gradlew_lastModified() {
  find . -type f -iname '*.gradle' -print0 | xargs -0 stat -c %Y | sort | tail -n 1
}

# 1: timestamp to save
function __gradlew_saveLastModified() {
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

function __gradlew_lastModifiedCached() {
  [ -f "$LAST_MOD_FILE" ] && cat "$LAST_MOD_FILE" || echo 0
}

function __gradlew_completions() {
  local last_mod=$(__gradlew_lastModified)
  local last_mod_cached=$(__gradlew_lastModifiedCached)
  if [ "$last_mod" -ne "$last_mod_cached" ]
  then
    __gradlew_refreshCache "$last_mod"
    __gradlew_saveLastModified "$last_mod"
  else
    __gradlew_loadCache
  fi
}

function __gradlew_refreshCache() {
  local tasks=$(./gradlew --quiet tasks --all | grep ' - ' | awk '{print $1}' | tr '\n' ' ')
  if [ -n "$tasks" ]
  then
    echo "$tasks"
    __gradlew_saveCache "$tasks"
  fi
}

_gradlew() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  _get_comp_words_by_ref -n : cur
  tasks=$(__gradlew_completions)
  COMPREPLY=( $(compgen -W "$tasks" -- $cur) )

  __ltrim_colon_completions "$cur"
}

complete -F _gradlew ./gradlew
