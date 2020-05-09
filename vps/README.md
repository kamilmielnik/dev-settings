# VPS Setup

1. Change password
```Shell
passwd
```

2. Update packages
```Shell
sudo apt-get update -y
sudo apt-get upgrade -y
```

## Setup nvm
1. Install nvm
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
