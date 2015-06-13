#
# Cookbook Name:: debian2proxmox
# Recipe:: default
#
# Copyright (C) 2015 Ameir Abdeldayem - Halabit, LLC
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
apt_repository "proxmox" do
  uri "http://download.proxmox.com/debian"
  distribution node['lsb']['codename']
  components ["pve-no-subscription"]
  key "http://download.proxmox.com/debian/key.asc"
end

template '/etc/hosts' do
  source 'hosts.erb'
end

packages = %w(pve-firmware pve-kernel-2.6.32-39-pve)
package packages

packages = %w(proxmox-ve-2.6.32 ntp ssh lvm2 postfix ksm-control-daemon vzprocps open-iscsi bootlogd)
package packages

packages = %w(linux-image-amd64 linux-image-3.2.0-4-amd64 linux-base linux-headers-3.2.0-4-amd64 linux-headers-3.2.0-4-common)
package packages do
  action :remove
  only_if 'echo "linux-image-3.2.0-4-amd64 linux-image-3.2.0-4-amd64/prerm/removing-running-kernel-3.2.0-4-amd64 boolean false" | debconf-set-selections'
  notifies :run, 'execute[update-grub]', :immediately
end

execute 'update-grub' do
  action :nothing
end
