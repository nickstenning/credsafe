. ./helpers.sh

#############################################################################

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'user' should fail and print help message"

setup
run credsafe user && fail
run_stdout | grep -qF 'Usage: credsafe user' || fail
pass

#############################################################################

start "'user add foo' should fail and print help message"

setup
run credsafe user add foo && fail
run_stdout | grep -qF 'Usage: credsafe user' || fail
pass

#############################################################################

start "'user add foo 3A432F3C' should add a user alias"

setup
run credsafe user add foo 3A432F3C || fail
run_stderr | grep -qF 'Added user foo (3A432F3C)' || fail
run credsafe user get foo || fail
run_stdout | grep -qF '3A432F3C' || fail
pass

#############################################################################

finish
