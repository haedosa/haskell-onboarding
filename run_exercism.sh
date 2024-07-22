#!/usr/bin/env bash

export EXERCISM_CONFIG_HOME=$PWD/exercism

while true; do
  echo -e "\nType the name of the exercise you want to start or type the below option."
  echo "- list : show the available exercises"
  echo "- gc : garbage collect the exercise development shell"
  echo "- test : check whether the code pass the test"
  echo "- submit : submit the exercism exercise"
  echo "- download : download the exercise submitted on exercism"
  echo "- quit : exit the script"

  read -r exercise_name

  exercise_devShell=${exercise_name}$(if [[ -n "$REPLIT_ENVIRONMENT" ]]; then echo "-replit"; fi)

  if [[ -z "${exercise_name}" ]]; then
    echo -e "\nNo input detected. Please try again."
  elif [[ "${exercise_name}" == "list" ]]; then
    echo -e "\nAvailable exercises:"
    cat exercism_list.txt
    echo -e "\n"
  elif [[ "${exercise_name}" == "gc" ]]; then
    echo -e "\nType the name of the exercise you want to garbage collect"
    read -r gc_exercise_name
    if [[ -d "exercism/haskell/${gc_exercise_name}" ]]; then
      ./gc.sh "${gc_exercise_name}"
    else
      echo -e "\nInvalid exercise name. Please try again."
    fi
  elif [[ "${exercise_name}" == "test" ]]; then
    echo -e "\nType the name of the exercise you want to test"
    read -r test_exercise_name
    if [[ -d "exercism/haskell/${test_exercise_name}" ]]; then
      test_exercise_devShell=${test_exercise_name}$(if [[ -n "$REPLIT_ENVIRONMENT" ]]; then echo "-replit"; fi)
      nix run .#${test_exercise_devShell}.test
    else
      echo -e "\nInvalid exercise name. Please try again."
    fi
  elif [[ "${exercise_name}" == "submit" ]]; then
    if [[ ! -f "exercism/user.json" ]]; then
      echo -e "\nNo token configured. Please provide your exercism token."
      read -r exercism_token
      exercism configure --token="$exercism_token" --workspace=$PWD/exercism
    fi
    echo -e "\nType the name of the exercise you want to submit"
    read -r submit_exercise_name
    if [[ -d "exercism/haskell/${submit_exercise_name}" ]]; then
      if [[ ! -f "exercism/haskell/$submit_exercise_name/.exercism/metadata.json" ]]; then
        echo -e "\nNo metada.json found. Downloading ..."
        mkdir -p "exercism/haskell/${submit_exercise_name}-tmp"
        cp -rf "exercism/haskell/${submit_exercise_name}/"* "exercism/haskell/${submit_exercise_name}-tmp/"
        exercism download --track=haskell --exercise="$submit_exercise_name" --force
        cp -rf "exercism/haskell/${submit_exercise_name}-tmp/"* "exercism/haskell/${submit_exercise_name}/"
        rm -rf "exercism/haskell/${submit_exercise_name}-tmp"
      fi
      exercism submit exercism/haskell/"$submit_exercise_name"/src/*
    else
      echo -e "\nInvalid exercise name. Please try again."
    fi
  elif [[ "$exercise_name" == "download" ]]; then
    if [[ ! -f "exercism/user.json" ]]; then
      echo -e "\nNo token configured. Please provide your exercism token."
      read -r exercism_token
      exercism configure --token="$exercism_token" --workspace=$PWD/exercism
    fi
    echo -e "\nType the name of the exercise you want to download"
    echo -e "Warning : existing files would be overwritten."
    read -r submit_exercise_name
    if [[ -d "exercism/haskell/$submit_exercise_name" ]]; then
      exercism download --track=haskell --exercise="$submit_exercise_name" --force
    else
      echo -e "\nInvalid exercise name. Please try again."
    fi
  elif [[ "$exercise_name" == "quit" ]]; then
    break
  elif [[ -d "exercism/haskell/$exercise_name" ]]; then
    mkdir -p .nix
    nix develop .#${exercise_devShell} --profile .nix/${exercise_devShell} --command bash -c "cd exercism/haskell/${exercise_name} && cabal repl lib:${exercise_name}"
  else
    echo -e "\nInvalid exercise name. Please try again."
  fi
done

: '
for dir in exercism/haskell/*/; do dir=${dir%/}; nix build --no-link .#devShells.x86_64-linux.${dir#exercism/haskell/}-replit; done && cd exercism/haskell && nix develop .#exercism-replit --command cabal repl lib:exercism
'
