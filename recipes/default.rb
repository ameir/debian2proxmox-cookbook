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

package 'install prerequisites' do
  package_name %w(ntp ssh lvm2 postfix ksm-control-daemon open-iscsi)
  action :install
end

case node['lsb']['codename']
when 'jessie'
  package %w(proxmox-ve)
when 'wheezy'
  package %w(pve-firmware pve-kernel-2.6.32-39-pve)
  package %w(proxmox-ve-2.6.32 vzprocps bootlogd)
end

kernel_package = "linux-image-#{node['kernel']['release']}"
packages = %W(linux-image-amd64 linux-base #{kernel_package})
package packages do
  action :remove
  only_if "echo '#{kernel_package} #{kernel_package}/prerm/removing-running-kernel-#{node['kernel']['release']} boolean false' | debconf-set-selections"
  only_if {kernel_package =~ /3\.(2|16)/}
  notifies :run, 'execute[update-grub]', :immediately
end

execute 'update-grub' do
  action :nothing
end
