# VPS Setup

For Ubuntu 20.04 on OVH VPS.

----

1. Change password
```Shell
passwd
```

2. Update packages
```Shell
sudo apt-get update -y
sudo apt-get upgrade -y
```

3. Setup common directories
```Shell
mkdir /var/www
mkdir ~/bin
mkdir ~/projects
mkdir /projects
```


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
sudo apt-get install -y gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm1
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

5. Link it in `/var/www`
```Shell
ln -s /projects/cv/build /var/www/cv
```

### Setup [scrabble-solver](https://github.com/kamilmielnik/scrabble-solver)
1. Clone it
```Shell
git clone git@github.com:kamilmielnik/scrabble-solver.git /projects/scrabble-solver/
```

3. Use v1
```Shell
cd /projects/scrabble-solver/
git checkout v1
```

4. Install it
```Shell
cd /projects/scrabble-solver/
npm i
npm run install-dictionaries
cd /projects/scrabble-solver/scrabble-solver-backend
npm i
cd /projects/scrabble-solver/scrabble-solver-frontend
npm i
cd /projects/scrabble-solver/
```

3. Build it
```Shell
npm run build:prod
```

4. Link it in `/var/www`
```Shell
ln -s /projects/scrabble-solver/dist/scrabble-solver-frontend /var/www/scrabble-solver
```

5. Allow connections to port 5000 in firewall
```Shell
sudo ufw allow 5000
```

6. Create logs directory
```Shell
mkdir /var/log/scrabble-solver
```

7. Add helpful scripts
```Shell
touch ~/bin/scrabble-solver-start.sh
chmod 755 ~/bin/scrabble-solver-start.sh
echo '#!/bin/bash' >> ~/bin/scrabble-solver-start.sh
echo 'nohup node /projects/scrabble-solver/dist/scrabble-solver-backend/index.js /projects/scrabble-solver/dictionaries/ </dev/null >/var/log/scrabble-solver/log.log 2>&1 &' >> ~/bin/scrabble-solver-start.sh
ln -s ~/bin/scrabble-solver-start.sh /usr/bin/scrabble-solver-start

touch ~/bin/scrabble-solver-kill.sh
chmod 755 ~/bin/scrabble-solver-kill.sh
echo '#!/bin/bash' >> ~/bin/scrabble-solver-kill.sh
echo 'ps aux | grep scrabble | grep node | awk '{print $2}' | xargs kill -9'  >> ~/bin/scrabble-solver-kill.sh
ln -s ~/bin/scrabble-solver-kill.sh /usr/bin/scrabble-solver-kill
```

8. Run backend server on startup
```Shell
echo '@reboot scrabble-solver-start' >> /etc/crontab
```

9. Run backend server (in the background)
```Shell
scrabble-solver-start
```

## Setup nginx + letsencrypt
1. Install certbot
- https://certbot.eff.org/lets-encrypt/ubuntufocal-nginx
```Shell
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y certbot
```

2. Run certbot
```Shell
sudo certbot certonly --standalone
```
- `kamilmielnik.com, kamilmielnik.pl, cv.kamilmielnik.com, cv.kamilmielnik.pl, scrabble-solver.kamilmielnik.com, scrabble-solver.kamilmielnik.pl`

3. Install nginx
```Shell
sudo apt-get install -y nginx
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
# check nginx status
systemctl status nginx

# stop server
sudo systemctl stop nginx

# start server
sudo systemctl start nginx

# restart server
sudo systemctl restart nginx

# reload config
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
sudo ufw enable -y
```

### Useful commands
```Shell
# Show firewall status
sudo ufw status
```

----

Now, reboot the VPS.
