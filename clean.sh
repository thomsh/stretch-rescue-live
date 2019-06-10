#!/bin/bash
set -euxo pipefail
cat .gitignore  |while read -r line
do
  sudo rm -rf -- ${line}
done
