#!/bin/bash

/usr/sbin/env-update
. /etc/profile

pushd /etc/portage
git stash
git pull
popd

equo i base-gcc
equo cleanup

#XXX: Until we have an official repos
rm -rfv /etc/entropy/repositories.conf.d/entropy_arm

exit 0
