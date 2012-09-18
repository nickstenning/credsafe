. ./helpers.sh

#############################################################################

start "'init' should create \$CREDSAFE_ROOT"

mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
echo 'joe' | run credsafe init

[ -d "$CREDSAFE_ROOT" ] || fail
pass

#############################################################################

start "'init' should confirm gpg key"

mock gpg 0 "pub:::::::::Joe Bloggs (Work) <joe@bloggs.com>:::"
echo 'joe' | run credsafe init

run_stderr | grep -qF "Joe Bloggs (Work) <joe@bloggs.com>" || fail
pass

#############################################################################

start "'init' should fail if gpg fails"

mock gpg 1
echo 'joe' | run credsafe init && fail
pass

#############################################################################

start "'init -c' should fail if \$CREDSAFE_ROOT doesn't exist"

run credsafe init -c && fail
run_stderr | grep -qF "run 'credsafe init' first" || fail
pass

#############################################################################

start "'init -c' should fail if \$CREDSAFE_ROOT/.git doesn't exist"

mkdir -p "${CREDSAFE_ROOT}/.git"
run credsafe init -c && fail
run_stderr | grep -qF "run 'credsafe init' first" || fail
pass

#############################################################################

start "'init -c' should fail if \$CREDSAFE_ROOT exists but isn't a git repo"

mkdir -p "$CREDSAFE_ROOT"
touch "${CREDSAFE_ROOT}/me"
run credsafe init -c && fail
run_stderr | grep -qF "is not a git repository" || fail
pass

#############################################################################

finish
