. ./helpers.sh

#############################################################################

start "'commands' should list commands"

run credsafe commands || fail
run_stdout | grep -qF 'add' || fail
run_stdout | grep -qF 'get' || fail
run_stdout | grep -qF 'commands' || fail
pass

#############################################################################

finish
