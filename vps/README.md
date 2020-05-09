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
mkdir ~/projects
mkdir /projects
chmod -R 777 /projects
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

## Setup nginx
TODO

## Setup firewall
```Shell
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow 'OpenSSH'
sudo ufw enable
sudo ufw status
```
