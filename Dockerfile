FROM debian:bookworm-slim

ARG NAME="rev9en/xwindow"
ARG VERSION="1.1.1"

LABEL version="${VERSION}"
LABEL description="Docker image with xwindow setup and rdp access"
LABEL created="2023-06-03"
LABEL maintainer="Evgen Rusakov"
LABEL url.docker="https://hub.docker.com/r/rev9en/xwindow"
LABEL url.source="https://github.com/revgen/docker/docker-xwindow"

ARG USERNAME=user
ENV USERNAME=${USERNAME}

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    \
    apt install -y supervisor curl wget rsync sudo && \
    \
    apt install -y locales && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    echo "export LC_ALL=\"en_US.UTF-8\"" >> /etc/profile && \
    echo "export LANG=\"en_US.UTF-8\"" >> /etc/profile && \
    echo "export LANGUAGE=\"en_US.UTF-8\"" >> /etc/profile && \
    \
    apt install -y fluxbox wmctrl xdotool xvfb x11-xserver-utils xxkb xterm && \
    apt install -y xrdp && \
    \
    mkdir -p /var/log/supervisor/ && \
    \
    echo "====[ Clean unused resources ]====" && \
    apt purge -y xfonts-75dpi && \
    apt purge -y xfonts-100dpi && \
    \
    ls /usr/share/i18n/locales/ | grep -v "_[A-Z][A-Z]$" | while read file; do rm -rf "/usr/share/i18n/locales/${file}"; done &&  \
    \
    rm -rf /usr/share/yudit && \
    rm -rf /usr/share/doc/* && \
    rm -rf /usr/share/man/* && \
    find /usr/share/locale -type d -maxdepth 1 -mindepth 1 ! -iname "en" -exec rm -rf "{}" \; && \
    find /usr/share/icons/ -mindepth 1 -maxdepth 1 ! -iname "default" -exec rm -rf "{}" \; && \
    find /usr/share/fonts/X11/misc/ -iname "*iso*.pcf.gz" -exec rm -f '{}' \; &&  \
    find /usr/share/fonts/X11/misc/ -iname "*ja.pcf.gz" -exec rm -f '{}' \; &&  \
    find /usr/share/fonts/X11/misc/ -iname "*ko.pcf.gz" -exec rm -f '{}' \; &&  \
    find /usr/share/fonts/X11/misc/ -iname "*koi8*.pcf.gz" -exec rm -f '{}' \; &&  \
    find /usr/share/fonts/X11/misc/ ! -iname "*x*.pcf.gz" -and ! -name "*unicode*.pcf.gz" \
        -and -iname "*.gz" -exec rm -f "{}" \; &&  \
    \
    rm -rf /usr/share/fluxbox/styles && mkdir /usr/share/fluxbox/styles && \
    \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    \
    useradd -m -s /bin/bash ${USERNAME} && \
    mkdir -p /home/${USERNAME}/.vnc && \
    echo "${USERNAME}            ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopwsudo && \
    echo "${USERNAME}:${USERNAME}1234" | chpasswd && \
    groupmod -g 220 dialout

COPY root-fs/etc/ /etc/
COPY root-fs/usr/ /usr
COPY root-fs/home/default/ /home/${USERNAME}/
COPY root-fs/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    \
    mkdir -p /home/${USERNAME}/.fluxbox/ && \
    mkdir -p /home/${USERNAME}/.local/bin && \
    \
    cp -v /etc/X11/fluxbox/keys /home/${USERNAME}/.fluxbox/keys && \
    cat "/home/${USERNAME}/.fluxbox/keys.extra" >> /home/${USERNAME}/.fluxbox/keys && \
    rm -f "/home/${USERNAME}/.fluxbox/keys.extra" && \
    \
    cat "/home/${USERNAME}/.bashrc.extra" >> /home/${USERNAME}/.bashrc && \
    rm -f "/home/${USERNAME}/.bashrc.extra" && \
    \
    chmod +x /home/${USERNAME}/.fluxbox/startup && \
    chown "${USERNAME}:${USERNAME}" -R "/home/${USERNAME}"

EXPOSE 5900 3389

ENTRYPOINT ["/entrypoint.sh"]
