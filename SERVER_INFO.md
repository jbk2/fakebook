# Server Documentation for Fakebook app
- This file's intention is as documentation for the server instance which these applications are deployed to:
  - fakebook.bibble.com
  - flight-booker@bibble.com
  - ubuntu@bibble.com (simple html page(s) hosted in docker nginx container)
  - portfolio.bibble.com (simple html page(s) hosted on docker nginx container)
  
Update this file, keep it synched with the github repo version, and save on the host server at /etc/docs/SERVER_INFO.md.

## General Information
- **Purpose**: An AWS EC2 instance to host multiple demo/portfolio apps, most dockerised and composed in separate contianers.
- **Public ipv4**: 13.38.128.29 (changes on every EC2 instance restart)
- **Domain Name**: currently DNS linked to www.bibble.com (via CloudFlare)
- **OS**: Ubuntu 20.04.4 LTS
- **EC2 Instance Type** t4g.small
- **Architecture**: ARM64
- **Region**: eu-west-3 (Paris)
- **Hostname**: ip-172-31-41-231.eu-west-3.compute.internal
- **AWS ami id**: ami-035e217195261eb8e

## Installed Software
- docker 26.1.4
- aws-cli 2.16.2
- nano 7.2
- curl 8.5.0
- at 3.2.5

## Security
- AWS security group incoming rules
  - all on http 80 and https 443
  - ssh 22 from James Kemp's CIPR range only
- Fail2Ban installed running, run ` sudo fail2ban-client status` to check status of jails.

## Docker Containers
- x5 dockerised containers, via ~/docker-compose.yml, built from AWS ECR images:
  - **ubuntu-nginx-1**
    - image built from; docker hub's 'nginx:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-nginx:1.0
      - **ubuntu-deploy-site** Nginx container also routes to an index.html page displaying html mark up of
        [this repository](https://github.com/jbk2/ubuntu-setup-deploy). This html file is volume mounted
        into the nginx container from the host ubuntu users' root; `- ./ubuntu-deploy-site/:/var/www/ubuntu-deploy-site/`
      - **portfolio-site** Nginx container also routes to a portfolio 'app', portfolio.bibble.com, simply an html page
        and it's accompanying styling assets. Repo [here](https://github.com/jbk2/portfolio). This 'app' is served from
        a volume mounted into the nginx container from this directory,`- ./portfolio-site/:/var/www/portfolio-site/`,
        at the host ubuntu users' home.
  - **ubuntu-postgres-1**
    - image built from; docker hub's 'postgres:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-postgres:1.0
  - **ubuntu-redis-1**
    - image built from; docker hub's 'redis:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-redis:1.0
  - **ubuntu-sidekiq-1**
    - image built from; prod.dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-sidekiq:1.1
  - **ubuntu-web-1**
    - image built from; prod.dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-web:1.2 <!-- the 1.2 tagged image was created from the built container which had manual updates ahead of the original built AWS ECR 1.1 image-->
  - **ubuntu-flight-booker-1**
    - image built from; dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-flight-booker:1.0

## Services Running
- HTTP Server on port 80
- SSH server on port 22 (15yr origin cert from 19.07.24)
- all server services are using same Cloudflare sourced SSL certificate.

## Variable Configuration
- The following variables must be defined in a .env file on both:
  - the host server ubuntu user's ~/ directory, and
  - the /usr/local/bin/ directory (for the use of the dns-settings.sh script)

In `.env`:
| Variable                              | Description                                                                |
|---------------------------------------|----------------------------------------------------------------------------|
| Fakebook Rails app related variables:                                                                              |
| `FAKEBOOK_RAILS_PRODUCTION_KEY`       | Fakebook app production env master key                                     |
| `FAKEBOOK_DATABASE_USER`              | Fakebook's username to access fakebook-db-1 postgres db cluster container  |
| `FAKEBOOK_DATABASE_PASSWORD`          | Fakebook user's fakebook-db-1 postgres cluster password                    |
|---------------------------------------|----------------------------------------------------------------------------|
| Flight-booker Rails app related variables:                                                                         |
| `FLIGHT_BOOKER_RAILS_PRODUCTION_KEY`  | Flight-booker app production env master key                                |
| `FLIGHT_BOOKER_DATABASE_USER`         | Flight-booker's username for fakebook-db-1 postgres db cluster container   |
| `FLIGHT_BOOKER_DATABASE_PASSWORD`     | Flight-booker user's fakebook-db-1 postgres cluster password               |
|---------------------------------------|----------------------------------------------------------------------------|
| EC2 instance setup.sh & settings.sh script related variables:                                                      |
| `SERVER`                              | Virtual machine public IP                                                  |
| `USER`                                | Name for the user that will replace *ubuntu* for administration            |
|                                       | (default 'deploy' is hardcoded)                                            |
| `SSH_KEY`                             | Path to the private SSH key                                                |
|---------------------------------------|----------------------------------------------------------------------------|
| dns-update.sh script related variables:                                                                            |
| `CF_API_TOKEN`                        | CloudFlare API token with the assigned domain's DNS editing permissions    |
| `ZONE_ID`                             | The zone id of the assigned domain name                                    |
| `RECORD_ID`                           | The DNS record ID number that needs updating on restart                    |
| `RECORD_NAME`                         | The DNS record name number that needs updating on restart                  |
|---------------------------------------|----------------------------------------------------------------------------|

## Configuration Changes
- `./nginx.conf` modified to serve all via SSL only.

## Maintenance Notes
- System updates every ...? - not automated.
  from local repo, not on server, run `.setup.sh -u update_upgrade`
- Daily backups at ...? - not authomated.
- DNS records updated via systemd service `dns-update.service`:
  - the service runs the executable `/dns-update.sh` script, all created by:
    - the executable `setup.sh` script, all located in /usr/local/bin.

## Helpful Commands
- `sudo systemctl status nginx`, `sudo systemctl status dns-update`, `sudo fail2ban-client status`

## Contact
- **Admin**: James Kemp, james@bibble.com
