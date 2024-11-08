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

_Here is how I create my bash array:_
```bash
while read line
do
   myarr[$index]=$line
   index=$(($index+1))
done < lines.txt
```
_You can extract words from a string (which is what the array elements are) using modifiers in the variable expansion: # (remove prefix), ## (remove prefix, greedy), % (remove suffix), and %% (remove suffix, greedy)._
```bash
$ echo "${myarr[0]}"      # Entire first element of the array
hello big world!
$ echo "${myarr[0]##* }"  # To get the last word, remove prefix through the last space
world!
$ echo "${myarr[0]%% *}"  # To get the first word, remove suffix starting with the first space
hello
$ tmp="${myarr[0]#* }"    # The second word is harder; first remove through the first space...
$ echo "${tmp%% *}"       # ...then get the first word of what remains
big
$ tmp="${myarr[0]#* * }"  # The third word (which might not be the last)? remove through the second space...
$ echo "${tmp%% *}"       # ...then the first word again
world!
```