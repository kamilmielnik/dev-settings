# dev-settings
My settings for various development tools

## Set up .bashrc
```
echo 'for filename in $HOME/bashrc/*.sh ; do' >> ~./bashrc
echo '   source "$filename"' >> ~./bashrc
echo 'done' >> ~./bashrc
```

## Set up .gitconfig
```
ln -s ~/projects/dev-settings/git/.gitconfig ~/.gitconfig
```
