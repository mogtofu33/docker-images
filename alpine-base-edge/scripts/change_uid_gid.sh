#!/bin/bash

echo "[i] Fix uid/gid started..."

# Get parameters.
USER_TO_CHANGE=(${1//:/ })
OLD_USER=${USER_TO_CHANGE[0]}
OLD_GROUP=${USER_TO_CHANGE[1]}
NEW_VALUES=(${2//:/ })
NEW_UID=${NEW_VALUES[0]}
NEW_GID=${NEW_VALUES[1]}

# Check if user exist.
USEREXISTS=$(cat /etc/passwd | grep -e "${OLD_USER}:" | wc -l)
if [ "$USEREXISTS" -ne 1 ]; then
  echo "[i] User '$OLD_USER' not found in /etc/passwd"
  exit 0
else
  OLD_UID=`id -u $OLD_USER`
fi

# Check if group exist.
GROUPEXISTS=$(cat /etc/group | grep -e "${OLD_GROUP}" | wc -l)
if [ "$GROUPEXISTS" -ne 1 ]; then
  echo "[i] Group '$OLD_GROUP' not found in /etc/group"
  exit 0
else
  OLD_GID=`getent group $OLD_GROUP | cut -d: -f3`
fi

# Check if uid/gid does not already exist.
UIDEXISTS=$(cat /etc/passwd | grep -e "[^:]*:[^:]*:$NEW_UID" | wc -l)
if [ "$UIDEXISTS" -ne 0 ] && [ "$OLD_UID" != "$NEW_UID" ]; then
  echo "[i] UID $NEW_UID already exists with an other user, skip usermod."
else
  # Set new uid.
  if [ "$OLD_UID" != "$NEW_UID" ]; then
    usermod -u ${NEW_UID} ${OLD_USER}
    echo "[i] User updated $OLD_UID > $NEW_UID"
  else
    echo "[i] User uid match."
  fi
fi

GIDEXISTS=$(cat /etc/group | grep -e "[^:]*:[^:]*:$NEW_GID" | wc -l)
if [ "$GIDEXISTS" -ne 0 ] && [ "$OLD_GID" != "$NEW_GID" ]; then
  echo "[i] GID $NEW_GID already exists with an other group, skip groupmod."
else
  # Set new gid.
  if [ "$OLD_GID" != "$NEW_GID" ]; then
    groupmod -g ${NEW_GID} ${OLD_GROUP}
    usermod -g ${NEW_GID} ${OLD_USER} 2>/dev/null
    echo "[i] Group updated $OLD_GID > $NEW_GID"
  else
    echo "[i] Group gid match."
  fi
fi

# Change folders uid/gid.
if [ "$OLD_UID" != "$NEW_UID" ] || [ "$OLD_GID" != "$NEW_GID" ]; then
  echo "[i] Update folders $OLD_UID:$OLD_GID > $NEW_UID:$NEW_GID..."
  find / \( -name proc -o -name dev -o -name sys \) -prune -o \( -user ${OLD_UID} -exec chown -Rfh ${NEW_UID}:${NEW_GID} {} \; \)
else
  echo "[i] No folders update needed."
fi
echo "[i] Update finished."
