default:
  just --list

check:
  moon check --deny-warn

test:
  moon test --target js

test-update:
  moon test --target js -u

run:
  moon run src/main --target js

fmt:
  moon fmt
