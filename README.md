# AWS QUICK SWITCH
Script for quick aws profile switching

### Install (For zsh )

```
  $ git clone https://github.com/matiri132/aws_quick_switch 
  $ chmod +x install.sh 
  $ ./install.sh 
  $ source ./~zshrc
```

Note: if you're not using zsh set the SOURCE variable in install.sh to your profile script.

### Use

- `aws_sp` will list all your aws configured acoounts.
- `aws_sp n` Will set the selected profile, where "n" is the profile NUMBER obtained by `aws_sp`.

