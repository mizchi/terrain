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

web:
  moon build --target js src/web
  cp _build/js/debug/build/web/web.js web.js

serve: web
  python3 -m http.server 8080
