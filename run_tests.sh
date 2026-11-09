#!/bin/bash
cd "$(dirname "$0")"

run() {
  case "$1" in
    js)     timeout 10 node runner.js solution.js < "$2" 2>/dev/null ;;
    py)     timeout 10 python3 solution.py < "$2" 2>/dev/null ;;
    php)    timeout 10 php solution.php < "$2" 2>/dev/null ;;
  esac
}

for lang in js py php; do
  pass=0; fail=0
  for t in tests/*.txt; do
    name=$(basename "$t" .txt)
    exp=$(cat "expected/$name.txt")
    got=$(run "$lang" "$t")
    if [ "$got" = "$exp" ]; then pass=$((pass+1));
    else echo "FAIL [$lang] $name  got='$got'  expected='$exp'"; fail=$((fail+1)); fi
  done
  echo "$lang: $pass passed, $fail failed"
done
