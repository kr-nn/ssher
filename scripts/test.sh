mode="$1"

test_all(){
  test_ping
  test_run
  test_script
  test_upload
  test_collect
  test_update
  test_manual
  test_expected_fails
}

test_ping(){
  echo "PING: ==============================================="
  echo "TEST: Ping mode: ./ssher ping -i ./_inv/test.inv"
  ./ssher ping -i ./_inv/test.inv
}

test_run(){
  echo "RUN: ==============================================="
  echo "TEST: Run mode: ./ssher run -i ./_inv/test.inv -c 'nixos-version'"
  ./ssher run -i ./_inv/test.inv -c 'nixos-version'
  echo "RUN FAIL: ==============================================="
  echo "TEST: Run mode: ./ssher run -i ./_inv/test.inv"
  ./ssher run -i ./_inv/test.inv
}

test_script(){
  echo "SCRIPT: ==============================================="
  echo "TEST: script mode: ./ssher script -i _inv/test.inv -l ./scripts/nixos-version"
  ./ssher script -i _inv/test.inv -l ./scripts/nixos-version

  echo ""
  echo "SCRIPT FAIL (file doesn't exist): ====================="
  ./ssher script -i _inv/test.inv -l ./scripts/asdf

  echo ""
  echo "SCRIPT FAIL (file not declared): ====================="
  ./ssher script -i _inv/test.inv
}

test_upload(){
  echo "UPLOAD: ==============================================="
  echo "TEST: upload mode: ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv"
  ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv
  echo "Checking uploaded file... ============================="
  ./ssher run -i _inv/test.inv -c 'cat inv'
  echo "Attempting append... =================================="
  ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv
  echo "Checking uploaded file... ============================="
  ./ssher run -i _inv/test.inv -c 'cat inv'
  echo "Attempting overwrite... ==============================="
  ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv
  echo "Checking uploaded file... ============================="
  ./ssher run -i _inv/test.inv -c 'cat inv'
  echo "Cleaning up... ========================================"
  ./ssher run -i _inv/test.inv -c 'rm inv'

  echo "UPLOAD FAIL (remote not defined): ====================="
  ./ssher upload -i _inv/test.inv -l _inv/asdf.inv
  echo "UPLOAD FAIL (local not defined): ======================"
  ./ssher upload -i _inv/test.inv -r inv
  echo "UPLOAD FAIL (both not defined): ======================="
  ./ssher upload -i _inv/test.inv
  echo "UPLOAD FAIL (local doesn't exist): ===================="
  ./ssher upload -i _inv/test.inv -l ./asdf -r inv
}

test_collect(){
  echo "COLLECT: =============================================="
  echo "Seeding file =========================================="
  ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv

  echo "TEST: Collect mode: ./ssher collect -i _inv/test.inv -l inv -r inv"
  ./ssher collect -i _inv/test.inv -l inv -r inv
  echo "Checking local file... ============================="
  cat inv
  echo "Cleaning up... ========================================"
  rm inv
  ./ssher run -i _inv/test.inv -c 'rm inv'

  echo "COLLECT FAIL (remote not defined): ====================="
  ./ssher collect -i _inv/test.inv -l _inv/asdf.inv
  echo "COLLECT FAIL (local not defined): ======================"
  ./ssher collect -i _inv/test.inv -r inv
  echo "COLLECT FAIL (both not defined): ======================="
  ./ssher collect -i _inv/test.inv
  echo "COLLECT FAIL (local doesn't exist): ===================="
  ./ssher collect -i _inv/test.inv -l ./asdf -r inv
}

test_update(){
  echo "UPDATE: ==============================================="
  echo "Seeding file =========================================="
  ./ssher upload -i _inv/test.inv -l _inv/test.inv -r inv
  ./ssher collect -i _inv/test.inv -l inv -r inv
  echo "Update this file so all servers have 1 item and remove this line" >> inv
  vim inv

  echo "TEST: Update mode: ./ssher update -i _inv/test.inv -l inv -r inv"
  ./ssher update -i _inv/test.inv -l inv -r inv
  echo "Checking uploaded file... ============================="
  ./ssher run -i _inv/test.inv -c 'cat inv'
  echo "Cleaning up... ========================================"
  ./ssher run -i _inv/test.inv -c 'rm inv'
  echo "upload file if not exists ============================="
  ./ssher update -i _inv/test.inv -l inv -r inv
  echo "final Cleaning up... ==================================="
  ./ssher run -i _inv/test.inv -c 'rm inv'
  rm inv

  echo "UPDATE FAIL (remote not defined): ====================="
  ./ssher update -i _inv/test.inv -l _inv/asdf.inv
  echo "UPDATE FAIL (local not defined): ======================"
  ./ssher update -i _inv/test.inv -r inv
  echo "UPDATE FAIL (both not defined): ======================="
  ./ssher update -i _inv/test.inv
  echo "UPDATE FAIL (local doesn't exist): ===================="
  ./ssher update -i _inv/test.inv -l ./asdf -r inv
}

test_manual(){
  echo "MANUAL: ==============================================="
  ./ssher man -i ./_inv/test.inv
}


test_expected_fails(){
  echo "TEST: Expected Fails =================================="
  echo "TEST: no mode ========================================="
  ./ssher -i ./_inv/test.inv
  echo "TEST: no inventory ===================================="
  ./ssher ping
  echo "TEST: inv doens't exist ==============================="
  ./ssher ping -i ./_inv/asdf.inv
}

case "$mode" in
  all)       test_all ;;
  ping)      test_ping ;;
  run)       test_run ;;
  script)    test_script ;;
  upload)    test_upload ;;
  collect)   test_collect ;;
  update)    test_update ;;
  manual)    test_manual ;;
  expected)  test_expected_fails ;;
  *) echo "usage: $0 {all|ping|run|script|upload|collect|update|manual|expected}" >&2; exit 1 ;;
esac

