# Server Documentation for Fakebook app
- This file's intention is as documentation for the server instance which hosts these containerised apps:
  - waldo-bibble.com
  - fakebook.bibble.com
  - flight-booker@bibble.com
  - ubuntu@bibble.com (simple html page(s) hosted in docker nginx container)
  - portfolio.bibble.com (simple html page(s) hosted on docker nginx container)
  
Update this file, keep it synched with the github repo version, and save on the host server at /etc/docs/SERVER_INFO.md.

## General Information
- **Purpose**: An AWS EC2 instance to host multiple demo/portfolio apps, most dockerised and composed in separate contianers.
- **Public ipv4**: 35.180.46.63 (changes on every EC2 instance restart)
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

## Server Security
- AWS security group incoming rules
  - all on http 80 and https 443
  - ssh 22 from James Kemp's CIPR range only, must update inbound rules in AWS console when ssh'ing into server from new IP address.
- Fail2Ban installed & running, run `sudo fail2ban-client status` to check status of jails.
  - it logs to /var/log/fail2ban.log.
  - common commands; `sudo fail2ban-client status`, `sudo fail2ban-client stop`, `sudo fail2ban-client start`,
    `sudo fail2ban-client reload`, `sudo fail2ban-client unban <ip address>`, `sudo fail2ban-client set <jail> unbanip <ip address>`

## Docker Containers
- x7 dockerised containers, via ~/docker-compose.yml, built from AWS ECR images:
  - **ubuntu-nginx-1**
    - image built from; docker hub's 'nginx:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-nginx:1.0
      - **ubuntu-deploy-site** Nginx container also routes to an index.html page displaying html mark up of
        [this repository](https://github.com/jbk2/ubuntu-setup-deploy). This html file is volume mounted
        into the nginx container from the host ubuntu users' root; `- ./ubuntu-deploy-site/:/var/www/ubuntu-deploy-site/`
      - (**NOW NOW LONGER USED**)**portfolio-site** Nginx container used to serve a statis html page for portfolio.bibble.com, simply an html page
        and it's accompanying styling assets. Repo [here](https://github.com/jbk2/portfolio). This 'app' was served from
        a volume mounted into the nginx container from this directory,`- ./portfolio-site/:/var/www/portfolio-site/`,
        at the host ubuntu users' home. NOW nginx routes portfolio-bibble.com to the full waldo-react app, which uses the waldo-rails API service.
  - **ubuntu-portfolio-react-1**
    - image built from; 'nginx:1.27-alpine' via ./Dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/portfolio-react:1.5
  - **ubuntu-postgres-1**
    - image built from; docker hub's 'postgres:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-postgres:1.0
  - **ubuntu-redis-1**
    - image built from; docker hub's 'redis:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-redis:1.0
  - **ubuntu-sidekiq-1**
    - image built from; prod.Dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-sidekiq:1.1
  - **ubuntu-web-1**
    - image built from; prod.Dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-web:2.4
  - **ubuntu-flight-booker-1**
    - image built from; Dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-flight-booker:1.0
  - **ubuntu-waldo-react-1**
    - image built from; prod.Dockerfile
    - ECR repo URI; 9964236740875.dkr.ecr.eu-west-3.amazonaws.com/waldo-rails:1.6
  - **ubuntu-waldo-rails-1**
    - image built from; prod.Dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/waldo-react:1.1
  - **ubuntu-battleship-1**
    - image built from; Dockerfile 
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/battleship:1.0
    - (note that service name is battleship but DNS is all battleships)

## DNS records & SSH certs
- There are two SSH certs which cover all of these domain DNS record:
  - Cloudflare Universal Cert - this covers non www subdomains, e.g. fakebook.bibble.com.
    This cert and key is located on host at /etc/nginx/ssl/..
  - LetsEncrypt SSL Cert - this covers www subdomains, e.g. www.fakebook.bibble.com, becuase the 
    Cloudflare Universal vert will not cover 4th level subdomains.
    This cert and key is located on host at /etc/nginx/ssl/www/..
- docker-compose.yml's nginx server defines a read only binding for these two cert sets into the nginx container.
- The DNS A records for the www.*.bibble.com have cloudflare proxy turned off, i.e. are set
  to SSL only so that the Let's Encrypt SSL allows the browser handshake to pass.
- After a www. subdomain handshake has passed the nginx.conf records define a redirect to the
  non-www. subdomain anyway, so visits remain proxied by cloudflare anyway.


## Services Running
- HTTP Server on port 80
- SSH server on port 22 (15yr origin cert from 19.07.24)
- all server services are using same Cloudflare sourced SSL certificate.

## Variable Configuration
- The following variables must be defined in a .env file on the host server
  ubuntu user's ~/ directory.

In `.env`:
| Variable                              | Description                                                                |
|---------------------------------------|----------------------------------------------------------------------------|
| Fakebook Rails app related variables:                                                                         |
| `RAILS_MASTER_KEY`                    | Fakebook app production env master key                                     |
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
| `NC_API_KEY`                          | Namecheap API key                                                          |
| `DNS_RECORD_NAMESANDIDS`              | The Cloudflare DNS record IDs for each domain for the script to update     |
|---------------------------------------|----------------------------------------------------------------------------|

## Configuration Changes
- `./nginx.conf` modified to serve all via SSL only.

## Maintenance Notes
- To update and upgrade the EC2 Ubuntu instance's packages, run this (from this local repo, not from the server);
  `.setup.sh -u update_upgrade`.
- System updates every ...? - not automated, currently only manual.
- Daily backups at ...? - not automated.
- DNS records updated via systemd service dns-update.service:
  - the service runs the executable '/usr/local/bin/dns-update.sh' script. This script is created and
    placed on the server when running the executable `setup.sh` script from this local repo.
  - Manually run the systemd service which runs the 'dns-update.sh' script by running
    `sudo systemctl start dns-update` from the server.
  - Check status of the script by running `systemctl status dns-update.service` from the server.
    (All systemd user services are located in /etc/systemd/system/) `sudo systemctl list-units --type=service`
  - The 'dns-update.service' is not automated, it must be run manually when instance public IP address
    is known to have changed.
  - The 'dns-update.service' logs to /var/log/dns-update.log.

## Helpful Commands
- `sudo systemctl status nginx`, `sudo systemctl status dns-update`, `sudo fail2ban-client status`,
  `sudo systemctl start/restart/enable/disable/status dns-update`

## Contact
- **Admin**: James Kemp, james@bibble.com
