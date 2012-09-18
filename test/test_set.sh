. ./helpers.sh

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'set' should fail and print help message"

setup
run credsafe set && fail
run_stdout | grep -qF 'Usage: credsafe set' || fail
pass

#############################################################################

start "'set foo' should fail if foo does not exist"

setup
mock gpg 0 "encrypted foo message"
echo 'foo message' | run credsafe set foo && fail
run_stderr | grep -qF 'does not exist' || fail
pass

#############################################################################

start "'set foo' should succeed if foo exists"

setup
touch "${CREDSAFE_ROOT}/db/foo.gpg"
mock gpg 0 "encrypted foo message"
echo 'foo message' | run credsafe set foo || fail
pass

#############################################################################

finish
