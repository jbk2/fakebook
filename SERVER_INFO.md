# Server Documentation for Fakebook app

- This file, /etc/docs/SERVER_INFO.md, is where info about this server instance will be stored.

## General Information
- **Purpose**: A facebook clone rails app, fully written by James Kemp, to practice and demonstrate ruby, rails, hotwire, html, css skills. Full description can be found in the README.md of [this](https://github.com/jbk2/fakebook) public repo.
- **Public ipv4**: 51.44.24.22 (changes on every EC2 instance restart)
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

## Docker Containers
- x5 dockerised containers, via ~/docker-compose.yml, built from AWS ECR images:
  - **ubuntu-sidekiq-1**
    - image built from; prod.dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-sidekiq:1.0
  - **ubuntu-web-1**
    - image built from; prod.dockerfile
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-web:1.0
  - **ubuntu-nginx-1**
    - image built from; docker hub's 'nginx:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-nginx:1.0
  - **ubuntu-postgres-1**
    - image built from; docker hub's 'postgres:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-postgres:1.0
  - **ubuntu-redis-1**
    - image built from; docker hub's 'redis:latest'
    - ECR repo URI; 964236740875.dkr.ecr.eu-west-3.amazonaws.com/fakebook-redis:1.0

## Services Running
- HTTP Server on port 80
- SSH server on port 22 (15yr origin cert from 19.07.24)

## Configuration Changes
- `./nginx.conf` modified to serve via SSL only.

## Maintenance Notes
- System updates every ...? - not automated.
  from local repo, not on server, run `.setup.sh -u update_upgrade`
- Daily backups at ...? - not authomated.


## Helpful Commands
- `sudo systemctl status nginx`, `sudo systemctl status dns-update`

## Contact
- **Admin**: James Kemp, james@bibble.com
