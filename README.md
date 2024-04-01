# About
nmap for SSH

# What this tool does
This tool is for auditability and automation. You can use it in place of ansible while using all the tooling you're already familiar with.
You can continue using sed/awk, manage embedded systems, any server with ssh can be managed with this tool.

# What is does NOT do
This tools does not replace ansible. ansible is an automation tool for Infrastructure as code. It ouputs json for this reason.
My tool is ansible for humans. It outputs in human readable format, easy to grep, output to reports and parse with your eyes.
This is not an ansible replacement, it's an ansible compliment.

# Best Practice
If you don't care about getting updates for this tool. ignore this section.
git is the deployment piece. all commonly used scripts go in the scripts folder.
the .gitignore files contains \_* so it will ignore all files and folders that start with an underscore.
It is best to copy scripts to \_scripts and edit them as needed.
Files that are not explicitly going to by synced to the repo should be in an _ folder
For ex.

`nmap -n -Pn -p 22 10.0.0.1/24 -oG - | grep "open:" | awk '{ print $2 }' >> _inventories/ lan.ips`

or 

`./ssher -m ping -i _inventories/lan.ips -u root -p | tee _reports/root_ssh.report`

Don't forget to read the help dialog on how to use ssher
