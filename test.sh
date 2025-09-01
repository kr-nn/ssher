#!/usr/bin/env bash

next() {
  echo ""
  echo "press any key to continue"
  read -n 1 key
  clear
}
title() {
  echo "$1"
  echo "==========================================="
}

# Test parser
## collision detection
title "Collision Detection Test: Normal Input"
./ssher test -i _inv/lab.ips -c "nixos-version" -l ./todo.md -r ./todo.md -d
next
title "Collision Detection Test: two inventory inputs"
./ssher test -i _inv/lab.ips --inventory _inv/lap.ips -c "nixos-version" -l ./todo.md -r ./todo.md -d
next
title "Collision Detection Test: two commands"
./ssher test -i _inv/lab.ips -c "nixos-version" --command "nixos-version" -l ./todo.md -r ./todo.md -d
next
title "Collision Detection Test: two localfiles"
./ssher test -i _inv/lab.ips -c "nixos-version" -l ./todo.md --localfile ./todo.md -r ./todo.md -d
next
title "Collision Detection Test: two remotefiles"
./ssher test -i _inv/lab.ips -c "nixos-version" -l ./todo.md --remotefile ./todo.md -r ./todo.md -d
next
title "Collision Detection Test: two passwords (sshpass should fail if not present)"
./ssher test -i _inv/lab.ips -c "nixos-version" -l ./todo.md -r ./todo.md --password -d
next
title "Collision Detection Test: two idfiles"
./ssher test -i _inv/lab.ips -c "nixos-version" -l ./todo.md -r ./todo.md --idfile ./todo.md -s ./todo.md
next
title "Collision Detection Test: two append inputs"
./ssher test -i _inv/lab.ips -c "nixos-version" --append o -a A -l ./todo.md -r ./todo.md -d
next

# Test preflight
## test required inputs
title "Required Inputs Test: mode is invalid"
./ssher asdf -i _inv/lab.ips -d
next
title "Required Inputs Test: inventory doesn't exist"
./ssher test -i _inv/nope.txt -d
next
title "Required Inputs Test: ping working"
./ssher ping -i _inv/lab.ips -d
next
title "Required Inputs Test: run fail"
./ssher run -i _inv/lab.ips -d
next
title "Required Inputs Test: run working"
./ssher run -i _inv/lab.ips -c "command" -d
next
title "Required Inputs Test: insert fail"
./ssher insert -i _inv/lab.ips -d
next
title "Required Inputs Test: append flag noinput"
./ssher insert -i _inv/lab.ips -d --append
next
title "Required Inputs Test: append flag bad input"
./ssher insert -i _inv/lab.ips -d --append asdf
next
title "Required Inputs Test: append flag overwrite"
./ssher insert -i _inv/lab.ips -d --append O -l ./todo.md -r ./todo.md
next
title "Required Inputs Test: append flag append"
./ssher insert -i _inv/lab.ips -d --append a -l ./todo.md -r ./todo.md
next
title "Required Inputs Test: insert only a localfile"
./ssher insert -i _inv/lab.ips -l ./todo.md -d
next
title "Required Inputs Test: insert only a remotefile"
./ssher insert -i _inv/lab.ips -r ./todo.md -d
next
title "Required Inputs Test: insert working"
./ssher insert -i _inv/lab.ips -l ./todo.md -r ./todo.md -d
next
title "Required Inputs Test: download fail"
./ssher download -i _inv/lab.ips -d
next
title "Required Inputs Test: download only a localfile"
./ssher download -i _inv/lab.ips -l ./todo.md -d
next
title "Required Inputs Test: download only a remotefile"
./ssher download -i _inv/lab.ips -r ./todo.md -d
next
title "Required Inputs Test: download working"
./ssher download -i _inv/lab.ips -l ./todo.md -r ./todo.md -d
next
title "Required Inputs Test: upload fail"
./ssher upload -i _inv/lab.ips -d
next
title "Required Inputs Test: upload only a localfile"
./ssher upload -i _inv/lab.ips -l ./todo.md -d
next
title "Required Inputs Test: upload only a remotefile"
./ssher upload -i _inv/lab.ips -r ./todo.md -d
next
title "Required Inputs Test: upload working"
./ssher upload -i _inv/lab.ips -l ./todo.md -r ./todo.md -d
next
title "Required Inputs Test: manual"
./ssher manual -i _inv/lab.ips -d
next

## test optional inputs
title "Optional Inputs Test: idfile working"
./ssher test -i _inv/lab.ips -s ~/.ssh/id_ed25519 -d -l ./todo.md -r ./todo.md -c "command"
next
title "Optional Inputs Test: idfile doesn't exist"
./ssher test -i _inv/lab.ips -s ~/.ssh/id -d -l ./todo.md -r ./todo.md -c "command"
next
title "Optional Inputs Test: idfile is not a valid key"
./ssher test -i _inv/lab.ips -s ./todo.md -d -l ./todo.md -r ./todo.md -c "command"
next

 Test modes
title "Live Tests: ping"
./ssher ping -i _inv/lab.ips
next
title "Live Tests: run"
./ssher run -i _inv/lab.ips -c "nixos-version --json"
next
title "Live Tests: script"
./ssher script -i _inv/lab.ips -l ./script-test.sh
next
title "Live Tests: insert append"
./ssher run -i _inv/lab.ips -c "echo 'initial content' > ~/.test-ssher.upload"
./ssher insert -i _inv/lab.ips -l ./todo.md -r ~/.test-ssher.upload --append a
./ssher run -i _inv/lab.ips -c "cat ~/.test-ssher.upload; rm -f ~/.test-ssher.upload"
next
title "Live Tests: insert overwrite"
./ssher run -i _inv/lab.ips -c "echo 'initial content' > ~/.test-ssher.upload"
./ssher insert -i _inv/lab.ips -l ./todo.md -r ~/.test-ssher.upload --append o
./ssher run -i _inv/lab.ips -c "cat ~/.test-ssher.upload; rm -f ~/.test-ssher.upload"
next
title "Live Tests: Download"
./ssher run -i _inv/lab.ips -c "echo 'initial content' > ~/.test-ssher.upload"
./ssher download -i _inv/lab.ips -l ./ssher.bundle -r ~/.test-ssher.upload
cat ./ssher.bundle
./ssher run -i _inv/lab.ips -c "rm -f ~/.test-ssher.upload"
next
title "Live Tests: Upload"
./ssher upload -i _inv/lab.ips -l ./ssher.bundle -r ~/.test-ssher.upload
./ssher run -i _inv/lab.ips -c "cat ~/.test-ssher.upload; rm ~/.test-ssher.upload"
rm -f ./ssher.bundle
next
