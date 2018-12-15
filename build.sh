#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154

usage() {
  echo "Usage: environment={dev|test|prod} $0 [-h]"
  exit 1
}
[ "$1" == "-h" ] && usage
[ -z "$environment" ] && usage

. data.sh

date=$(date +%Y%m%d%H%M%S)

cat > variables.json <<EOF
{
  "vpc": "$vpc_id",
  "subnet": "$subnet_id",
  "aws_region": "$aws_region",
  "owner": "123456789012",
  "date": "$date",
  "instance_type": "$instance_type"
}
EOF
jq . variables.json > /dev/null || exit $?

for action in validate build ; do
  packer $action -var-file=variables.json \
    packer.json || exit $?
done

rm -f variables.json
