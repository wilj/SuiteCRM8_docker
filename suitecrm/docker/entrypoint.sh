#!/usr/bin/env bash

if [ -z $ROOT_URL ]; then
  echo "ROOT_URL is required"
  exit 1
fi

randompassword() {
  openssl rand -base64 $1 | tr '+/' '-_' | tr -d '\n'
}

if [ -z "$DEFAULT_ADMIN_USER" ]; then
  echo "DEFAULT_ADMIN_USER environment variable not set"
  ADMIN_USER="admin"
  echo "Using generated admin user '$ADMIN_USER'"
else
  ADMIN_USER=$DEFAULT_ADMIN_USER
fi

if [ -z "$DEFAULT_ADMIN_PASSWORD" ]; then
  echo "DEFAULT_ADMIN_PASSWORD environment variable not set"
  ADMIN_PASSWORD=$(randompassword 8)
  echo "Using generated admin password '$ADMIN_PASSWORD'"
else
  ADMIN_PASSWORD=$DEFAULT_ADMIN_PASSWORD
fi

if [ -z "$INSTALL_DEMO_DATA" ]; then
  echo "INSTALL_DEMO_DATA environment variable not set, defaulting to 'no'"
  INSTALL_DEMO_DATA=no
fi

set -euxo pipefail

echo "Entrypoint running for ROOT_URL ${ROOT_URL}"

SERVER_NAME=$(echo "$ROOT_URL" | sed 's/https:\/\///g')
SITES_CONF=/etc/apache2/sites-enabled/sites.conf
export SERVER_NAME

echo "Adding 'ServerName $SERVER_NAME' to $SITES_CONF"
cat /etc/apache2/sites-enabled/sites.conf.template \
  | envsubst \
  | tee $SITES_CONF

INSTALL_DIR=/var/www/html/SuiteCRM
if [[ -d "$INSTALL_DIR/public" ]]; then
  echo "SuiteCRM already installed at $INSTALL_DIR"
else
  TMPFILE=/tmp/suitecrm.zip
  wget -q https://suitecrm.com/files/147/SuiteCRM-8.0/596/SuiteCRM-8.0.1.zip -O $TMPFILE
  mkdir -p $INSTALL_DIR
  unzip -q $TMPFILE -d $INSTALL_DIR/
  rm $TMPFILE

  chmod +x $INSTALL_DIR/bin/console
  echo "Running silent install with ROOT_URL ${ROOT_URL}"
  # 
  #   Install the application
  #
  # Usage:
  #   suitecrm:app:install [options]
  # Options:
  #   -U, --db_username=DB_USERNAME            database username
  #   -P, --db_password=DB_PASSWORD            database password
  #   -H, --db_host=DB_HOST                    database host
  #   -Z, --db_port=DB_PORT                    database port
  #   -N, --db_name=DB_NAME                    database name
  #   -u, --site_username=SITE_USERNAME        site username
  #   -p, --site_password=SITE_PASSWORD        site password
  #   -S, --site_host=SITE_HOST                site host
  #   -d, --demoData[=DEMODATA]                Install "demo data" during install process
  #   -W, --sys_check_option=SYS_CHECK_OPTION  Ignore "system check warnings" during install system acceptance check
  #   -h, --help                               Display help for the given command. When no command is given display help for the list command
  #   -q, --quiet                              Do not output any message
  #   -V, --version                            Display this application version
  #       --ansi                               Force ANSI output
  #       --no-ansi                            Disable ANSI output
  #   -n, --no-interaction                     Do not ask any interactive question
  #   -e, --env=ENV                            The Environment name. [default: "prod"]
  #       --no-debug                           Switch off debug mode.
  #   -v|vv|vvv, --verbose                     Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug

  $INSTALL_DIR/bin/console suitecrm:app:install \
    --site_username="$ADMIN_USER" \
    --site_password="$ADMIN_PASSWORD" \
    --db_username="$MARIADB_USER" \
    --db_password="$MARIADB_PASSWORD" \
    --db_host="$MARIADB_HOST" \
    --db_name="$MARIADB_DATABASE" \
    --demoData="$INSTALL_DEMO_DATA" \
    --site_host="${ROOT_URL}" \
    --env="$ENV_NAME" \
    --no-interaction \
    -vv

  echo "Silent install complete"
  chown -R www-data:www-data /var/www
  echo "Permissions set on /var/www"
fi

echo "Checking SMTP settings..."
set +u
CONFIG_SMTP="no"
if [ -z "$SMTP_HOST" ]; then
  echo "SMTP_HOST not set. Skipping SMTP setup."
else
  echo "Using SMTP_HOST $SMTP_HOST"
  CONFIG_SMTP="yes"
fi
set -u

if [ $CONFIG_SMTP = "yes" ]; then
  echo "Configuring SMTP..."
# # BEGIN TODO COMMENTS

  mysql --user="$MARIADB_USER" --password="$MARIADB_PASSWORD" --host="$MARIADB_HOST" "$MARIADB_DATABASE" <<..EOF
    update config 
    set value = '$SMTP_FROM_ADDRESS'
    where category = 'notify'
      and name = 'fromaddress';
..EOF

  mysql --user="$MARIADB_USER" --password="$MARIADB_PASSWORD" --host="$MARIADB_HOST" "$MARIADB_DATABASE" <<..EOF
    update config 
    set value = '$SMTP_FROM_NAME'
    where category = 'notify'
      and name = 'fromname';
..EOF
  
  mysql --user="$MARIADB_USER" --password="$MARIADB_PASSWORD" --host="$MARIADB_HOST" "$MARIADB_DATABASE" <<..EOF
    insert into config 
      (category, name, value) values
      ('notify', 'allow_default_outbound','2');
..EOF

  mysql --user="$MARIADB_USER" --password="$MARIADB_PASSWORD" --host="$MARIADB_HOST" "$MARIADB_DATABASE" <<..EOF
    update outbound_email set 
      mail_smtpauth_req = 0,
      mail_smtpserver = '$SMTP_HOST',
      mail_smtpport = '$SMTP_PORT',
      smtp_from_name = '$SMTP_FROM_NAME',
      smtp_from_addr = '$SMTP_FROM_ADDRESS'
    where name = 'system'
      and type = 'system';
..EOF

fi


echo "Starting apache"
apachectl restart
sleep 5
tail -f /var/log/apache2/*
