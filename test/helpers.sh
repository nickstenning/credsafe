ANSI_RED="\033[31m"
ANSI_GREEN="\033[32m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

TEST_FAILCNT="0"
TEST_NAME="Default"

cd "$(dirname "$0")"
export TEST_ROOT="$(pwd)"

export CREDSAFE_ROOT="${TEST_ROOT}/.fixtureroot"

export TEST_BIN="$(cd "${TEST_ROOT}/../bin"; pwd)"
export TEST_MOCKBIN="${TEST_ROOT}/.mockbin"

export TEST_RUN_STDOUT="$(mktemp -t credsafe_test_stdout.XXXXXX)"
export TEST_RUN_STDERR="$(mktemp -t credsafe_test_stderr.XXXXXX)"

cleanup () {
  unmock
  rm -f "$TEST_RUN_STDOUT" "$TEST_RUN_STDERR"
  rm -rf "$CREDSAFE_ROOT"
}

start () {
  TEST_NAME="$@"
  TEST_FAILED=""
  cleanup
}

pass () {
  if [ -z "$TEST_FAILED" ]; then
    echo "${ANSI_GREEN}${ANSI_BOLD}PASS:${ANSI_RESET} ${TEST_NAME}" >&2
  fi
}

fail () {
  if [ -z "$TEST_FAILED" ]; then
    echo "${ANSI_RED}${ANSI_BOLD}FAIL:${ANSI_RESET}${ANSI_RED} ${TEST_NAME}${ANSI_RESET}" >&2
  fi

  TEST_FAILED="yes"
  TEST_FAILCNT=$(($TEST_FAILCNT + 1))
}

finish () {
  [ -z "$CREDSAFE_TEST_DEBUG" ] && cleanup
  exit "$TEST_FAILCNT"
}

mock () {
  progname="$1"
  retcode="$2"
  shift
  shift

  mkdir -p "$TEST_MOCKBIN"
  cat >"${TEST_MOCKBIN}/${progname}" <<EOM
echo "$@"
exit "$retcode"
EOM
  chmod +x "${TEST_MOCKBIN}/${progname}"
}

unmock () {
  rm -rf "$TEST_MOCKBIN"
}

run () {
  echo -n >"$TEST_RUN_STDOUT"
  echo -n >"$TEST_RUN_STDERR"
  "$@" >"$TEST_RUN_STDOUT" 2>"$TEST_RUN_STDERR"
}

run_stdout () {
  cat "$TEST_RUN_STDOUT"
}

run_stderr () {
  cat "$TEST_RUN_STDERR"
}

export PATH="${TEST_BIN}:${PATH}"
export PATH="${TEST_MOCKBIN}:${PATH}"

cleanup
