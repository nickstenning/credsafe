. ./helpers.sh

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'add' should fail and print help message"

setup
run credsafe add && fail
run_stdout | grep -qF 'Usage: credsafe add' || fail
pass

#############################################################################

start "'add foo' should not fail"

setup
mock gpg 0 "encrypted foo message"
echo 'foo message' | run credsafe add foo || fail
pass

#############################################################################

finish
