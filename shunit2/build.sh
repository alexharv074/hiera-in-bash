#!/usr/bin/env bash

script_under_test=$(basename $0)

tearDown() {
  command rm -f commands_log expected_variables expected_log
  command rm -f variables.json
}

date() {
  echo "date $*" >> commands_log
  echo "20181215173000"
}

rm() {
  echo "rm $*" >> commands_log
}

packer() {
  echo "packer $*" >> commands_log
}

testUsage() {
  expected_output="Usage: environment={dev|test|prod} shunit2/build.sh [-h]"
  actual_output=$(. $script_under_test -h)
  assertEquals "unexpected output when running script with no args" \
    "$expected_output" "$actual_output"
}

testEnvNotSet() {
  expected_output="Usage: environment={dev|test|prod} shunit2/build.sh [-h]"
  actual_output=$(. $script_under_test)
  assertEquals "unexpected output when running script with no args" \
    "$expected_output" "$actual_output"
}

testIllegalEnv() {
  expected_output="Data file ./data/environment/I_am_wrong.sh not found"
  actual_output=$(environment='I_am_wrong' . $script_under_test | head -1)
  assertEquals "unexpected output when running script with no args" \
    "$expected_output" "$actual_output"
}

testCommandsLogged() {
  cat > expected_log <<'EOF'
date +%Y%m%d%H%M%S
packer validate -var-file=variables.json packer.json
packer build -var-file=variables.json packer.json
rm -f variables.json
EOF
  environment='dev' . $script_under_test

  assertEquals "unexpected sequence of commands issued" \
    "" "$(diff -wu expected_log commands_log)"
}

testDevData() {
  cat > expected_variables <<'EOF'
{
  "vpc": "vpc-11111111",
  "subnet": "subnet-11111111",
  "aws_region": "ap-southeast-2",
  "owner": "123456789012",
  "date": "20181215173000",
  "instance_type": "t2.micro"
}
EOF
  environment='dev' . $script_under_test

  assertEquals "unexpected Packer variables file generated" \
    "" "$(diff -wu expected_variables variables.json)"
}

testProdData() {
  cat > expected_variables <<'EOF'
{
  "vpc": "vpc-33333333",
  "subnet": "subnet-33333333",
  "aws_region": "ap-southeast-2",
  "owner": "123456789012",
  "date": "20181215173000",
  "instance_type": "t2.large"
}
EOF
  environment='prod' . $script_under_test

  assertEquals "unexpected Packer variables file generated" \
    "" "$(diff -wu expected_variables variables.json)"
}

. shunit2
