#!/bin/bash
set -e
message=${1:-"hugo deploy"}
hugo --destination docs
git add .
git commit -m "$message"
git push