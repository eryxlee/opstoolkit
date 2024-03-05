#! /bin/sh
#
# Copyright (C) 2023 lazywhite <lazywhite@qq.com>
#
# Distributed under terms of the MIT license.
#

which snap
if [ $? -ne 0 ];then
  echo "snap binary not found"
  exit 0
fi

snap remove --purge lxd
snap remove --purge core20
snap remove --purge snapd
apt remove -y --autoremove snapd
