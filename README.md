# dev-settings
My settings for various development tools

## Set up .bashrc
```
touch ~/.node-version
echo '12.14.0' >> ~/.node-version

echo '' >> ~/.bashrc
echo 'for filename in ~/projects/dev-settings/bashrc/*.sh ; do' >> ~/.bashrc
echo '   source "$filename"' >> ~/.bashrc
echo 'done' >> ~/.bashrc
source ~/.bashrc
```

## Set up .gitconfig
```
ln -s ~/projects/dev-settings/git/.gitconfig ~/.gitconfig
```
