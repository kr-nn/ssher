echo "TEST: Successful runs ================================="

echo "TEST: Ping mode: ./ssher -m ping -i ./_inv/test.inv"
./ssher -m ping -i ./_inv/test.inv
echo "======================================================="

echo "TEST: Run mode: ./ssher -m run -i ./_inv/test.inv -c 'nixos-version'"
./ssher -m run -i ./_inv/test.inv -c 'nixos-version'
echo "======================================================="

echo "TEST: script mode: ./ssher -m script -i ./_inv/test.inv -l ./script/test"
./ssher -m script -i ./_inv/test.inv -l ./scripts/test
echo "======================================================="

echo "TEST: insert mode: ./ssher -m ins -i ./_inv/test.inv -l ./scripts/test -r ./test.txt"
./ssher -m ins -i ./_inv/test.inv -l ./scripts/test -r './test.txt'
echo "confirming file is there and contains the test script"
./ssher -m run -i ./_inv/test.inv -c 'cat ./test.txt'
echo "======================================================="

echo "TEST: download mode: ./ssher -m download -i ./_inv/test.inv -l ./download.file -r ./test.txt"
./ssher -m download -i ./_inv/test.inv -l ./download.file -r './test.txt'
echo "Removing file from remote server"
./ssher -m run -i ./_inv/test.inv -c 'rm -f ./test.txt'
echo "======================================================="

echo "TEST: upload mode: ./ssher -m upload -i ./_inv/test.inv -l ./download.file -r ./test.txt"
./ssher -m upload -i ./_inv/test.inv -l ./download.file -r './test.txt'
echo "Confirming file is there and contains the test script"
./ssher -m run -i ./_inv/test.inv -c 'cat ./test.txt'
echo "Cleanup file"
./ssher -m run -i ./_inv/test.inv -c 'rm -f ./test.txt'
echo "======================================================="

echo "TEST: manual mode: "
./ssher -m man -i ./_inv/test.inv
echo "======================================================="

echo "TEST: Expected Fails ================================="

echo "TEST: no mode"
./ssher -i ./_inv/test.inv

echo "TEST: no inventory"
./ssher -m ping

echo "TEST: no file"
./ssher -m ping -i ./_inv/asdf.inv

echo "TEST: Run mode (-c fail): ./ssher -m run -i ./_inv/test.inv -c 'nixos-version'"
./ssher -m run -i ./_inv/test.inv
echo "======================================================="


