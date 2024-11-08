# LAE-gruppe-arma-setup

- tools for updating arma 3 server without manually copying all addon folders
- compiled array list: `WorkshopID SPACE folderRename`


## Notes for updater development:
[repeat command N times](https://stackoverflow.com/questions/3737740/is-there-a-better-way-to-run-a-command-n-times-in-bash)

_If your range has a variable, use seq, like this:_

```bash
count=10
for i in $(seq $count); do
    command
done
```

_Simply:_

```bash
for run in {1..10}; do
  command
done
```

[Extract element from array](https://stackoverflow.com/questions/15685736/how-to-extract-a-particular-element-from-an-array-in-bash)
