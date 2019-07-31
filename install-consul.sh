readonly DEFAULT_INSTALL_PATH="/opt/consul"
readonly DEFAULT_CONSUL_USER="consul"
readonly DOWNLOAD_PACKAGE_PATH="/tmp/consul.zip"

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SYSTEM_BIN_DIR="/usr/local/bin"

readonly SCRIPT_NAME="$(basename "$0")"

function install_dependencies {
  echo "Installing dependencies"

  sudo apt-get update -y
  sudo apt-get install -y curl unzip jq
}

function create_consul_install_paths {
  local -r path="$1"

  echo "Creating install dirs for Consul at $path"
  sudo mkdir -p "$path"
  sudo mkdir -p "$path/bin"
  sudo mkdir -p "$path/bin/run-consul"
  sudo mkdir -p "$path/config"
  sudo mkdir -p "$path/data"
  sudo mkdir -p "$path/tls/ca"
}

function fetch_binary {
  local -r version="$1"

  if [[ ! -z "$version" ]];  then
    download_url="https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip"

    echo "Downloading Consul to $DOWNLOAD_PACKAGE_PATH"
    curl -o $DOWNLOAD_PACKAGE_PATH $download_url --location --show-error
  fi
}

function install_binary {
  local -r install_path="$1"

  local -r bin_dir="$install_path/bin"
  local -r consul_dest_path="$bin_dir/consul"
  local -r run_consul_dest_path="$bin_dir/run-consul"

  unzip -d /tmp "$DOWNLOAD_PACKAGE_PATH"

  echo "Moving Consul binary to $consul_dest_path"
  sudo mv "/tmp/consul" "$consul_dest_path"
  sudo chmod a+x "$consul_dest_path"

  local -r symlink_path="$SYSTEM_BIN_DIR/consul"
  if [[ -f "$symlink_path" ]]; then
    echo "Symlink $symlink_path already exists. Will not add again."
  else
    echo "Adding symlink to $consul_dest_path in $symlink_path"
    sudo ln -s "$consul_dest_path" "$symlink_path"
  fi
}

path=/home/ec2-user/consul
version=1.5.3

install_dependencies
create_consul_install_paths "$path"
fetch_binary "$version"
install_binary "$path"
