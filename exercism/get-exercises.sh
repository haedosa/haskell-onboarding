#!/usr/bin/env bash
# Download in batch exercises from an Exercism track

# @author: Daniel Souza <me@posix.dev.br>
# @license: MIT
# @usage: get-exercises.sh <lang>
# @deps: curl, jq
# @source: https://github.com/danisztls/exercism/blob/main/get-exercises

# Utils
# decorators
reset="\e[0;0m"
strong="\e[1;39m"
blue="\e[1;34m"
red="\e[1;31m"
yellow="\e[1;33m"
green="\e[1;32m"

# Main
script_name="$0"
lang="$1"
token="$2"
force="$3"
url="https://exercism.org/api/v2/tracks/${lang}/exercises"

if [[ "$script_name" == "/nix/store"* ]]; then
  script_name="nix run .#get-exercises --"
fi

# Check if language argument is provided
if [ -z "${lang}" ]; then
  echo -e "${strong}${red}Error: Please provide the language as the script argument.${reset}"
  echo -e "${strong}${yellow}Usage: ${script_name} <lang> <token> <force>${reset}"
  echo -e "${strong}${yellow}Example: ${script_name} haskell 00000000-0000-0000-0000-000000000000 --force${reset}"
  echo -e "${strong}${yellow}Example: ${script_name} python 00000000-0000-0000-0000-000000000000${reset}"
  exit 1
fi

# Check if token is set
if [ -z "${token}" ]; then
  echo -e "${strong}${red}Error: Please set your Exercism API token as the script argument.${reset}"
  echo -e "${strong}${yellow}Usage: ${script_name} <lang> <token> <force>${reset}"
  echo -e "${strong}${yellow}Example: ${script_name} haskell 00000000-0000-0000-0000-000000000000 --force${reset}"
  echo -e "${strong}${yellow}Example: ${script_name} python 00000000-0000-0000-0000-000000000000${reset}"
  exit 1
fi

echo -e "${strong}${yellow}\nSetting token...${reset}\n"
exercism configure --token=${token}

echo -e "${strong}${yellow}Getting list of exercises\t${reset}\n\n"

exercises=$(
  curl -H "Authorization: Bearer ${token}" -S "$url" |
  jq '.[] | .[] | select(.is_unlocked == true) | .slug' |
  sed 's/"//g'
)

n=$(wc -l <<< "$exercises")
i=0

echo -e "${strong}${yellow}\nDownloading ${n} exercises...${reset}\n"

exercism configure -w .

# exercism download --exercise="bob" --track="${lang}" ${force}
# pushd "${lang}"/bob
# hpack
# ln -sf ../.envrc .envrc
# git add .
# popd

while read -r exercise; do
  i=$((i + 1))

  if [ ! -d "${lang}/${exercise}" ] || { [ ! -z "${force}" ] && [ "${force}" == "--force" ]; }; then
    echo -e "${strong}\n${i}. ${blue}${exercise}... ${green}GET${reset}"
    exercism download --exercise="${exercise}" --track="${lang}" ${force}
    # pushd "${lang}"/"${exercise}"
    # hpack
    # ln -sf ../.envrc .envrc
    # git add .
    # popd
  else
    echo -e "${strong}\n${i}. ${blue}${exercise}... ${yellow}NOOP${reset}"
  fi
done <<< "$exercises"

echo -e "${strong}${green}\nAll done!${reset}\n"
