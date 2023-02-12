# Wordpress on [fly.io](https://fly.io/)

A starting point for deploying a Wordpress application to [fly.io](https://fly.io/).

Based on [wordpress-env](https://github.com/hunterashaw/wordpress-env).

## Features

-   Fully dockerized & repeatable.
-   Uses [SQLite plugin](https://github.com/aaemnnosttv/wp-sqlite-db) simple database management.
-   Runs on locally & on [fly.io](https://fly.io/)

## Prerequisites

-   [Docker](https://www.docker.com/products/docker-desktop/)
-   [Create fly.io Account](https://fly.io/app/sign-up)
-   [Install `flyctl` CLI](https://fly.io/docs/hands-on/install-flyctl/)
-   [`flyctl` CLI Login](https://fly.io/docs/hands-on/sign-in/)

## WIP

- This doesn't cover getting `wp-content/uploads` to persist within a volume, but this can be done using the instructions for the `database` volume

## Local Setup & Startup

Same as [wordpress-env](https://github.com/hunterashaw/wordpress-env)

## Deployment

1. Create fly.io application:
```
fly launch
```

2. Fill out `fly launch` questions:

| Question                                                | Tip                                                  |
| ------------------------------------------------------- | ---------------------------------------------------- |
| Choose an app name (leave blank to generate one):       | Must be globally unique                              |
| Choose a region for deployment:                         | Pick the closest region (remember the 3-letter code) |
| Would you like to set up a Postgresql database now?     | No                                                   |
| Would you like to set up an Upstash Redis database now? | No                                                   |
| Create .dockerignore from 1 .gitignore files?           | Yes                                                  |
| Would you like to deploy now?                           | No (we stil need to set up a volume)                 |

3. Create a volume for the `wp-content/database` directory. This creates a 1gb volume associated with our new app (make sure you replace $REGION_CODE with the 3-letter code from above):
```
fly volumes create wordpress_database --region $REGION_CODE --size 1
```

4. Replace the `[env]` line in `fly.toml` with the following lines:
```
[build.args]
  PORT=8080

[mounts]
  source="wordpress_database"
  destination="/var/www/html/wp-content/database"

[env]
  WORDPRESS_CONFIG_EXTRA=""
```

5. Deploy app:
```
fly deploy
```

6. Ensure deployment was successful. You can view the deployment progress in your [fly.io dashboard](https://fly.io/dashboard) > [your new app] > Monitoring

7. [SSH into VM and fix volume permission issue](https://community.fly.io/t/cant-create-sqlite-database-in-mounted-volume/2925/4). `fly.io` gives the `root` user ownership of the mounted volume, which we must manually fix by running: 
```
fly ssh console
chown -R www-data /var/www/html/wp-content/database
```

8. Go to the application URL listed in your [fly.io dashboard](https://fly.io/dashboard) > [your new app] > Overview

9. Follow the Wordpress installation instructions.