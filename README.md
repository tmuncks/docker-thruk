# docker-thruk
This is a simple docker image for running [Thruk](https://www.thruk.org/).

### Run with docker-compose
Here is an example docker-compose.yml with a very simple setup:

```
services:
  # logcache database
  db:
    image: mariadb
    restart: always
    environment:
      - TZ=America/Nuuk
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=thrukdb
      - MYSQL_USER=thrukdbuser
      - MYSQL_PASSWORD=password
    volumes:
      - /var/lib/mysql

  # thruk itself
  thruk:
    image: tmuncks/thruk
    depends_on:
      - db
    restart: always
    environment:
      - TZ=America/Nuuk
      - LOGCACHE=mysql://thrukdbuser:password@db:3306/thrukdb
    volumes:
      - /etc/thruk
      - /var/lib/thruk
      - ./thruk:/etc/thruk/thruk_local.d:ro
    ports:
      - 8080:80
```

### Initial credentials
A random password is set for the default `thrukadmin` user, when deploying the application. This password will be printed in the log:

docker-compose logs thruk
```
...
thruk_1  | 
thruk_1  | ### The password for thrukadmin has been set to: Co#hoo6wi1oe
thruk_1  | 
...
```

### Configuration
Files (`*.conf`) can be put in `/etc/thruk/thruk_local.d` via mounts, as an easy way to drop configuration snippets in the container.

### Mail
The image has sSMTP installed, as a very lightweight MTA.

Configuration for sSMTP can be mounted on `/etc/ssmtp`.

MAN page for sSMTP can be found [here](https://manpages.debian.org/stable/ssmtp/ssmtp.8.en.html).

### Persistence
Anonymous volumes have been put in place to persist configuration (`/etc/thruk`) and data (`/var/lib/thruk`).

These paths can be mounted on named volumes for better control, visibility etc.

### Documentation
The actual Thruk Documentation can be found [here](https://www.thruk.org/documentation/).