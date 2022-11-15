#!/bin/bash

echo "What have you done?";read commit;

fold="$(dirname "$0")"

cd "$gitfold"

git add .

git commit -m "$commit"

git push