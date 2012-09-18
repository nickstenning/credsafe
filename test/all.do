exec >&2
set -e

for test in test_*.sh; do
  /bin/sh "$test"
done
