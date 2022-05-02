# AWS QUICK SWITCH
Script for quick aws profile switching

### Configure (Optional)

You can change some values in the script as:
* AWS_CRED: Where the AWS credentials file is located. ~/.aws/credentials as default.
* AWS_CONF: Where the AWS confgi file is located. ~/.aws/config as default.
* VERBOSE: If you set this to 1, you can get the list of profiles with this source profile associated.

### Install (For zsh )

```
  $ git clone https://github.com/matiri132/aws_quick_switch 
  $ chmod +x install.sh 
  $ ./install.sh 
  $ source ./~zshrc
```

Note: if you're not using zsh set the SOURCE variable in install.sh to your profile script.

### Use

- `aws_sp` will list all your aws configured profiles with this source profile if its a assumed one.
- `aws_sp n` Will set the selected profile, where "n" is the profile NUMBER obtained by `aws_sp`.

