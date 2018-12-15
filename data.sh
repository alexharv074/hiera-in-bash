data_dir=./data

usage() {
  echo "Usage: environment={dev|test|prod} . $0"
  exit 1
}
[ -z "$environment" ] && usage

if [ ! -e "$data_dir/environment/${environment}.sh" ]; then
  echo "Data file $data_dir/environment/${environment}.sh not found"
  usage
fi

# Hierarchy.
. $data_dir/common.sh
. $data_dir/environment/${environment}.sh
