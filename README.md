# SuiteCRM 8 Docker

This project is a fork of [https://github.com/jontitmus-code/SuiteCRM8_docker](https://github.com/jontitmus-code/SuiteCRM8_docker) with automated installation and configuration.

---

## Run locally

To run this project locally, either Docker + Docker Compose, or Vagrant + Virtualbox are required.

### Docker + Docker Compose
    # edit localhost.env to change any desired settings, then:
    ./run-localhost.sh


### Vagrant + Virtualbox
    # cd into the project root folder where the Vagrantfile is located
    vagrant up
---
## Run instantly on Gitpod

### [Click here to try it now on Gitpod.io](https://gitpod.io/#https://github.com/wilj/SuiteCRM8_docker)

The Gitpod workspace configuration will automatically build, install, and run SuiteCRM, MariaDB, phpMyAdmin, and MailHog.

As the services are launched, their ports will be exposed via HTTPS, and notifications will appear:

![Open port notifications](docs/images/suitecrm-gitpod-ports-screenshot.png)

The ports can be accessed at any time from the port list:
![Open port list](docs/images/suitecrm-gitpod-ports-list-screenshot.png)

phpMyAdmin may throw errors if browsed to before the database is fully populated.

---

## Accessing services

The following ports are forwarded:

* 8080 - SuiteCRM
* 8025 - MailHog web interface
  * This project preconfigures SuiteCRM to use the local MailHog SMTP server.
  * Emails are not persisted on restart.
* 8181 - phpMyAdmin
  * Preconfigured to connect to SuiteCRM database.
* 3306 - MariaDB

---

## Logging In

The initial admin user name and password can be set by environment variable:

    DEFAULT_ADMIN_USER
    DEFAULT_ADMIN_PASSWORD

If the default user/password variables are blank or unset, they will default to "admin" and a randomly generated password will be printed to the log output with the text "Using generated admin password \<password\>"
