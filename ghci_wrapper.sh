#!/usr/bin/env bash

if [[ "$#" == 0 ]]; then
    exec cabal repl ex-from-fp-course
fi

# This is needed to run the `main` function by default.
#{ echo main ; cat - ; } | exec ghci "$@"
