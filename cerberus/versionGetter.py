import os
import sys
# the purpose of this script is to get the version of the current project from the pubspec.yaml file, chop of version: and export the version number to the environment variable versionNum

# get the current working directory
cwd = os.getcwd()
# get the pubspec.yaml file
pubspec = open(cwd + "/pubspec.yaml", "r")
# read the file
pubspecContent = pubspec.read()
# look through the file and look for the line that contains "version:"
for line in pubspecContent.splitlines():
    if "version:" in line:
        # if the line contains "version:" then split the line at the ":"
        versionNum = line.split(":")[1]
        # remove the space after the ":"
        versionNum = versionNum[1:]
        # export the version number to a file since the environment variable being exported isn't avaliable to bash, only to child processes
        versionNumFile = open(cwd + "/versionNum.txt", "w")
        versionNumFile.write(versionNum)
        versionNumFile.close()
        # print the version number
        print(versionNum)
        # exit the script
        sys.exit()