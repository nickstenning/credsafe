exec >&2
set -e

echo "Running tests in $SHELL"

for test in test_*.sh; do
  $SHELL "$test"
done
