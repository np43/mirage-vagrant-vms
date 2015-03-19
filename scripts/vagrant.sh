#!/bin/sh
#
# Copyright (c) 2015 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

set -ex

date > /etc/vagrant_box_build_time

useradd -G sudo --create-home -s /bin/bash vagrant || true

mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate                                             \
     'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' \
     -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

echo 'vagrant:vagrant' | chpasswd
echo 'UseDNS no' >> /etc/ssh/sshd_config
echo "vagrant ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i -e "s/Defaults    requiretty/#Defaults    requiretty/g" /etc/sudoers

mkdir -p /vagrant || true

echo 'Welcome to your Vagrant-built virtual machine.' > /var/run/motd || true

apt-get -y install nfs-common nfs-kernel-server
