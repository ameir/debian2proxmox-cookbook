# debian2proxmox-cookbook
This cookbook converts a Debian installation to Proxmox.  It installs pve-kernel
and the other required tools, and removes the existing kernel.  This is expected
to be run on a fresh Debian installation.  This can be destructive, so take care
that the host you're running this on has nothing important on it, and is indeed
fresh.  I won't be responsible for lost data.

## Supported Platforms

debian

## Prerequisites
You must have Debian 7 or 8 installed.  Additionally, the following packages must
be installed:
`apt-get -y install lsb-release curl sudo rsync`

## Usage
You can install this a variety of ways.  One of the easiest is with
[chef-runner](https://github.com/mlafeldt/chef-runner), which will package up the
cookbook and its dependencies, rsync them to the target host, and run chef-solo.

`chef-runner -i true --sudo=false -H root@host`

## License and Authors

Author:: Ameir Abdeldayem
