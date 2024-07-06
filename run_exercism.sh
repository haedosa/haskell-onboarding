#!/usr/bin/env bash

while true; do
  echo -e "\nType the name of the exercise you want to start or type the below option."
  echo "- list : show the available exercises"
  echo "- gc : garbage collect the exercise development shell"
  echo "- quit : exit the script"

  read -r exercise_name

  if [[ -z "$exercise_name" ]]; then
    echo -e "\nNo input detected. Please try again."
  elif [[ "$exercise_name" == "list" ]]; then
    echo -e "\nAvailable exercises:"
    cat exercism_list.txt
    echo -e "\n"
  elif [[ "$exercise_name" == "gc" ]]; then
    echo -e "\nType the name of the exercise you want to garbage collect"
    read -r gc_exercise_name
    if [[ -d "exercism/haskell/$gc_exercise_name" ]]; then
      ./gc.sh "$gc_exercise_name"
    else
      echo -e "\nInvalid exercise name. Please try again."
    fi
  elif [[ "$exercise_name" == "quit" ]]; then
    break
  elif [[ -d "exercism/haskell/$exercise_name" ]]; then
    exercise_devShell=${exercise_name}$(if [[ -n "$REPLIT_ENVIRONMENT" ]]; then echo "-replit"; fi)
    mkdir -p .nix
    nix develop .#${exercise_devShell} --profile .nix/${exercise_devShell} --command bash -c "cd exercism/haskell/${exercise_name} && cabal repl lib:${exercise_name}"
  else
    echo -e "\nInvalid exercise name. Please try again."
  fi
done

: '
for dir in exercism/haskell/*/; do dir=${dir%/}; nix build --no-link .#devShells.x86_64-linux.${dir#exercism/haskell/}-replit; done && cd exercism/haskell && nix develop .#exercism-replit --command cabal repl lib:exercism
'
