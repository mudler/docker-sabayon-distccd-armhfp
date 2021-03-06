FROM sabayon/base-armhfp

MAINTAINER mudler <mudler@sabayonlinux.org>

# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ADD ./ext/qemu-arm-static /usr/bin/qemu-arm-binfmt

RUN rsync -av "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/" && \
        ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

# Adding repository url
ADD ./confs/entropy_arm /etc/entropy/repositories.conf.d/entropy_arm

RUN equo rescue spmsync &&  equo up && equo u && equo i distcc gcc base-gcc

# Cleaning accepted license2s
RUN rm -rf /etc/entropy/packages/license.accept

RUN echo -5 | equo conf update

# Perform post-upgrade tasks (mirror sorting, updating repository db)
ADD ./scripts/setup.sh /setup.sh
RUN /bin/bash /setup.sh  && rm -rf /setup.sh

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /

CMD ["/usr/bin/distccd", "--allow", "0.0.0.0/0", "--user", "distcc", "--log-level", "notice", "--log-stderr", "--no-detach"]

EXPOSE 3632


