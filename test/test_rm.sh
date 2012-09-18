. ./helpers.sh

setup () {
  mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
  echo 'joe' | credsafe init >/dev/null 2>&1
  unmock
}

#############################################################################

start "'rm' should fail and print help message"

setup
run credsafe rm && fail
run_stdout | grep -qF 'Usage: credsafe rm' || fail
pass

#############################################################################

start "'rm foo' should fail if foo doesn't exist"

setup
run credsafe rm foo && fail
run_stderr | grep -qF 'does not exist' || fail
pass

#############################################################################

start "'rm foo' should not fail if foo exists"

setup
touch "${CREDSAFE_ROOT}/db/foo.gpg"
run credsafe rm foo || fail
pass

#############################################################################

finish
