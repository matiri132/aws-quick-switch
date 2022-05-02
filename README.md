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
  $ chmod +x INSTALL.sh 
  $ ./INSTALL.sh 
  $ source ./~zshrc
```

Note: if you're not using zsh set the SOURCE variable in INSTALL.sh to your profile script.

### Autocompletion

The INSTALL.sh script will ask you to install autocompletion. This *ONLY* works for zsh.
Now with TAB you can choose your AWS profile. 

### WARNING
The instalation script writes directly to you zshrc file, also before the instalation makes a copy in this folder if you want to revert the changes.
You can find the file *zshrc.backup*. After the instalation and check the script is working you can delete the file.

### Use

- `aws_sp` will list all your aws configured profiles with this source profile if its a assumed one.
- `aws_sp n` Will set the selected profile, where "n" is the profile NUMBER obtained by `aws_sp`.

