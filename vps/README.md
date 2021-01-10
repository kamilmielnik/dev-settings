# VPS Setup

For Ubuntu 20.04 on OVH VPS.

- [Basic settings](#basic-settings)
- [Setup node](#setup-node)
- [Setup nvm](#setup-nvm)
- [Setup git](#setup-git)
- [Setup projects](#setup-projects)
  - [Setup dev-settings](#setup-dev-settings)
  - [Setup cv](#setup-cv)
  - [Setup scrabble-solver v1](#setup-scrabble-solver-v1)
  - [Setup scrabble-solver](#setup-scrabble-solver)
- [Setup nginx + letsencrypt](#setup-nginx--letsencrypt)
- [Setup firewall](#setup-firewall)

### Useful commands

```Shell
# upload contents of '~/my-directory' to '/var/www/my-directory' on example.com, assuming target directory exists
scp -r ~/my-directory/* user@example.com:/var/www/my-directory
```

---

## Basic settings

1. Change password

```Shell
passwd
```

2. Update packages

```Shell
sudo apt update -y
sudo apt upgrade -y
```

3. Setup common directories

```Shell
mkdir /var/www
mkdir ~/bin
mkdir ~/projects
mkdir /projects
```

## Setup node

https://github.com/nodesource/distributions/blob/master/README.md#debinstall

```Shell
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
```

Now, reboot the VPS.

## Setup nvm

1. Install nvm

- https://github.com/nvm-sh/nvm#install--update-script

```Shell
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
```

2. Reload shell to have nvm in PATH

```Shell:
source ~/.bashrc
```

3. Install latest LTS node

```Shell
nvm install --lts
```

4. Install useful node packages globally

```Shell
npm i -g fuck-npm grab-files npkill npm-check-updates
```

## Setup git

1. Generate SSH key

```Shell
ssh-keygen -t rsa -b 4096 -C "kamil.adam.mielnik@gmail.com"
```

2. Start ssh-agent

```Shell
eval "$(ssh-agent -s)"
```

3. Add SSH key to ssh-agent

```Shell
ssh-add ~/.ssh/id_rsa
```

4. Show SSH key to add to GitHub

```Shell
cat ~/.ssh/id_rsa.pub
```

5. Copy the SSH key and add it to GitHub: https://github.com/settings/ssh/new

## Setup projects

### Setup [dev-settings](https://github.com/kamilmielnik/dev-settings/)

1. Clone it

```Shell
git clone git@github.com:kamilmielnik/dev-settings.git ~/projects/dev-settings/
```

2. Setup `.bashrc`

```Shell
echo '' >> ~/.bashrc
echo 'for filename in ~/projects/dev-settings/bashrc/*.sh ; do' >> ~/.bashrc
echo '   source "$filename"' >> ~/.bashrc
echo 'done' >> ~/.bashrc
source ~/.bashrc
```

3. Setup `.gitconfig`

```Shell
ln -s ~/projects/dev-settings/git/.gitconfig ~/.gitconfig
```

### Setup [cv](https://github.com/kamilmielnik/cv/)

1. Install packages required for puppeteer to work server-side

- https://github.com/puppeteer/puppeteer/issues/3443#issuecomment-433096772
- https://github.com/puppeteer/puppeteer/issues/4098#issuecomment-568227160
- https://github.com/puppeteer/puppeteer/issues/5704#issuecomment-618372226

```Shell
sudo apt install -y gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm1
```

2. Clone it

```Shell
git clone git@github.com:kamilmielnik/cv.git /projects/cv/
```

3. Set up `.env`

```Shell
cp /projects/cv/.env.example /projects/cv/.env
```

4. Build it

```Shell
cd /projects/cv
npm i
npm run build
```

5. Create logs directory

```Shell
mkdir /var/log/cv
```

6. Add service scripts to `/usr/bin`

```Shell
chmod 755 ~/projects/dev-settings/vps/bin/cv-start.sh
ln -s ~/projects/dev-settings/vps/bin/cv-start.sh /usr/bin/cv-start

chmod 755 ~/projects/dev-settings/vps/bin/cv-stop.sh
ln -s ~/projects/dev-settings/vps/bin/cv-stop.sh /usr/bin/cv-stop
```

7. Create `cv.service` to run server on system startup

```Shell
ln -s ~/projects/dev-settings/vps/services/cv.service /etc/systemd/system/cv.service
sudo systemctl daemon-reload
sudo systemctl enable cv.service
```

8. Start the service

```Shell
sudo systemctl start cv.service
```

### Useful commands

```Shell
# show service status
sudo systemctl status cv.service

# enable the service
sudo systemctl enable cv.service

# restart the service
sudo systemctl restart cv.service

# start the service
sudo systemctl start cv.service

# stop the service
sudo systemctl stop cv.service

# remove the service
sudo systemctl disable cv.service

# show logs
cat /var/log/cv/log.log
```

### Setup [scrabble-solver v1](https://github.com/kamilmielnik/scrabble-solver/tree/v1)

1. Clone it

```Shell
git clone git@github.com:kamilmielnik/scrabble-solver.git /projects/scrabble-solver-v1/
```

2. Use v1

```Shell
cd /projects/scrabble-solver-v1/
git checkout v1
```

3. Install it

```Shell
cd /projects/scrabble-solver-v1
npm i
npm run install-dictionaries
cd /projects/scrabble-solver-v1/scrabble-solver-backend
npm i
sudo apt install -y python2 make g++
cd /projects/scrabble-solver-v1/scrabble-solver-frontend
npm i
```

4. Build it

```Shell
cd /projects/scrabble-solver-v1
npm run build:prod
```

5. Link it in `/var/www`

```Shell
ln -s /projects/scrabble-solver-v1/dist/scrabble-solver-frontend /var/www/scrabble-solver-v1
```

6. Allow connections to port 5000 in firewall

```Shell
sudo ufw allow 5000
```

7. Create logs directory

```Shell
mkdir /var/log/scrabble-solver-v1
```

8. Add service scripts to `/usr/bin`

```Shell
chmod 755 ~/projects/dev-settings/vps/bin/scrabble-solver-v1-start.sh
ln -s ~/projects/dev-settings/vps/bin/scrabble-solver-v1-start.sh /usr/bin/scrabble-solver-v1-start

chmod 755 ~/projects/dev-settings/vps/bin/scrabble-solver-v1-stop.sh
ln -s ~/projects/dev-settings/vps/bin/scrabble-solver-v1-stop.sh /usr/bin/scrabble-solver-v1-stop
```

9. Create `scrabble-solver-v1.service` to run backend on system startup

```Shell
ln -s ~/projects/dev-settings/vps/services/scrabble-solver-v1.service /etc/systemd/system/scrabble-solver-v1.service
sudo systemctl daemon-reload
sudo systemctl enable scrabble-solver-v1.service
```

10. Start the service

```Shell
sudo systemctl start scrabble-solver-v1.service
```

### Useful commands

```Shell
# show service status
sudo systemctl status scrabble-solver-v1.service

# enable the service
sudo systemctl enable scrabble-solver-v1.service

# restart the service
sudo systemctl restart scrabble-solver-v1.service

# start the service
sudo systemctl start scrabble-solver-v1.service

# stop the service
sudo systemctl stop scrabble-solver-v1.service

# remove the service
sudo systemctl disable scrabble-solver-v1.service

# show logs
cat /var/log/scrabble-solver-v1/log.log
```

### Setup [scrabble-solver](https://github.com/kamilmielnik/scrabble-solver/)

1. Clone it

```Shell
git clone git@github.com:kamilmielnik/scrabble-solver.git /projects/scrabble-solver/
```

2. Install it

```Shell
cd /projects/scrabble-solver
npm i
npm run install:dev
```

3. Create logs directory

```Shell
mkdir /var/log/scrabble-solver
```

4. Add service scripts to `/usr/bin`

```Shell
chmod 755 ~/projects/dev-settings/vps/bin/scrabble-solver-start.sh
ln -s ~/projects/dev-settings/vps/bin/scrabble-solver-start.sh /usr/bin/scrabble-solver-start

chmod 755 ~/projects/dev-settings/vps/bin/scrabble-solver-stop.sh
ln -s ~/projects/dev-settings/vps/bin/scrabble-solver-stop.sh /usr/bin/scrabble-solver-stop
```

5. Create `scrabble-solver.service` to run server on system startup

```Shell
ln -s ~/projects/dev-settings/vps/services/scrabble-solver.service /etc/systemd/system/scrabble-solver.service
sudo systemctl daemon-reload
sudo systemctl enable scrabble-solver.service
```

6. Start the service

```Shell
sudo systemctl start scrabble-solver.service
```

### Useful commands

```Shell
# show service status
sudo systemctl status scrabble-solver.service

# enable the service
sudo systemctl enable scrabble-solver.service

# restart the service
sudo systemctl restart scrabble-solver.service

# start the service
sudo systemctl start scrabble-solver.service

# stop the service
sudo systemctl stop scrabble-solver.service

# remove the service
sudo systemctl disable scrabble-solver.service

# show logs
cat /var/log/scrabble-solver/log.log
```

## Setup nginx + letsencrypt

1. Install certbot

- https://certbot.eff.org/lets-encrypt/ubuntufocal-nginx

```Shell
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt install -y certbot
```

2. Run certbot

```Shell
sudo certbot certonly --standalone
```

- `kamilmielnik.com, kamilmielnik.pl, cv.kamilmielnik.com, cv.kamilmielnik.pl, scrabble-solver.kamilmielnik.com, scrabble-solver.kamilmielnik.pl`

3. Install nginx

```Shell
sudo apt install -y nginx
```

4. Replace `nginx.conf`

```Shell
rm /etc/nginx/nginx.conf
ln -s ~/projects/dev-settings/vps/nginx/nginx.conf /etc/nginx/nginx.conf
```

5. Remove default site

```Shell
rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
rm -rf /var/www/html
```

6. Setup sites

```Shell
ln -s ~/projects/dev-settings/vps/nginx/sites-available/* /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/
```

7. Restart nginx

```Shell
sudo systemctl restart nginx
```

8. Add `renew-certificates.sh` to daily crontab

```Shell
chmod 755 ~/projects/dev-settings/vps/nginx/renew-certificates.sh
ln -s ~/projects/dev-settings/vps/nginx/renew-certificates.sh /etc/cron.daily/renew-certificates.sh
```

### Useful commands

```Shell
# show service status
sudo systemctl status nginx

# stop the service
sudo systemctl stop nginx

# start the service
sudo systemctl start nginx

# restart the service
sudo systemctl restart nginx

# reload service config
sudo systemctl reload nginx

# test config syntax
sudo nginx -t

# show error.log
cat /var/log/nginx/error.log

# show access.log
cat /var/log/nginx/access.log
```

## Setup firewall

```Shell
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow 'OpenSSH'
sudo ufw enable
```

### Useful commands

```Shell
# Show firewall status
sudo ufw status
```

---

Now, reboot the VPS.
