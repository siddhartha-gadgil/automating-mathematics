#!/bin/bash
set -e
hugo --destination docs
git add .
git commit -m "hugo deploy"
