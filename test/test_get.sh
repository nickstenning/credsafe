. ./helpers.sh

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'get' should fail and print help message"

setup
run credsafe get && fail
run_stdout | grep -qF 'Usage: credsafe get' || fail
pass

#############################################################################

start "'get foo' should fail if foo doesn't exist"

setup
run credsafe get foo && fail
run_stderr | grep -qF 'does not exist' || fail
pass

#############################################################################

start "'get foo' should not fail if foo exists"

setup
mock gpg 0 "foo message"
touch "${CREDSAFE_ROOT}/db/foo.gpg"
run credsafe get foo || fail
run_stdout | grep -q '^foo message$' || fail
pass

#############################################################################

finish
