#!/bin/bash
set -e
SCRIPT_NAME="$(basename "${0}")"

export XWINDOW_DISPLAY="${XWINDOW_DISPLAY:-":10.0"}"
export XWINDOW_RESOLUTION="${XWINDOW_RESOLUTION:-"1280x780"}"

echo "Update password for the main user"
if [ -n "${PASSWORD}" ]; then
    echo "${USERNAME}:${PASSWORD}" | chpasswd
fi
if [ "${PUID}" ]; then
    groupmod -g "${PGID}" "${USERNAME}"
    usermod -u "${PUID}" -g "${PGID}" "${USERNAME}"
fi
chown ${USERNAME}:${USERNAME} -R /home/${USERNAME}

unset PASSWORD
echo "Start supervisor..."
exec /usr/bin/supervisord -c "/etc/supervisor/conf.d/supervisord.conf"
