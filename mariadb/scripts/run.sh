#!/bin/bash

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  ./scripts/change_uid_gid.sh mysql:mysql $LOCAL_UID:$LOCAL_GID
fi

# Fix my.cnf permissions
chown mysql:mysql /etc/mysql/my.cnf
chmod 644 /etc/mysql/my.cnf

if [ ! -d "/run/mysqld" ]; then
  mkdir -p /run/mysqld
  chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  chown -R mysql:mysql /var/lib/mysql

  mysql_install_db --user=mysql > /dev/null

  MYSQL_DATABASE=${MYSQL_DATABASE:-""}
  MYSQL_USER=${MYSQL_USER:-""}
  MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
EOF

  if [ "$MYSQL_DATABASE" != "" ]; then
      echo "[i] Creating database: $MYSQL_DATABASE"
      echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

      if [ "$MYSQL_USER" != "" ]; then
        echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
        echo "GRANT ALL ON *.* to '$MYSQL_USER'@'%';" >> $tfile
      fi
      echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" >> $tfile
      echo "FLUSH PRIVILEGES;" >> $tfile
  fi

  /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
  #rm -f $tfile
fi

exec /usr/bin/mysqld --user=mysql --console
