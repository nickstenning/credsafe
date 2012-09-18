. ./helpers.sh

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'list' should output nothing if the database is empty"

setup
run credsafe list || fail
pass

#############################################################################

start "'list' should list credentials"

setup
mkdir -p "${CREDSAFE_ROOT}/db/sub"
touch "${CREDSAFE_ROOT}/db/a.gpg"
touch "${CREDSAFE_ROOT}/db/sub/b.gpg"
touch "${CREDSAFE_ROOT}/db/sub/c.gpg"
run credsafe list || fail
run_stdout | grep -qF "a" || fail
run_stdout | grep -qF "sub/b" || fail
run_stdout | grep -qF "sub/c" || fail
pass

#############################################################################

start "'list foo' should list credentials starting with foo"

setup
mkdir -p "${CREDSAFE_ROOT}/db/sub"
touch "${CREDSAFE_ROOT}/db/a.gpg"
touch "${CREDSAFE_ROOT}/db/sub/b.gpg"
touch "${CREDSAFE_ROOT}/db/sub/c.gpg"
run credsafe list sub || fail
run_stdout | grep -qF "a" && fail
run_stdout | grep -qF "sub/b" || fail
run_stdout | grep -qF "sub/c" || fail
pass

#############################################################################

start "'list foo' should list nothing if no credentials start with foo"

setup
mkdir -p "${CREDSAFE_ROOT}/db/sub"
touch "${CREDSAFE_ROOT}/db/a.gpg"
touch "${CREDSAFE_ROOT}/db/sub/b.gpg"
touch "${CREDSAFE_ROOT}/db/sub/c.gpg"
run credsafe list foo || fail
run_stdout | grep -qF "a" && fail
run_stdout | grep -qF "sub/b" && fail
run_stdout | grep -qF "sub/c" && fail
pass

#############################################################################

finish
