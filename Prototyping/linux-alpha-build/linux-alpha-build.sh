#!/bin/sh
echo -ne '\033c\033]0;Landing Test\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/linux-alpha-build.x86_64" "$@"
