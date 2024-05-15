# Jprojects
Personal Projects made by jadon

jsFIM.ps1 is a File Integrity Monitor that stores file paths and their hashes in a txt file named baseline.txt. The program scans any file in a folder named /Files and creates a hash for them and checks the hash of each file in /Files every second. if a file is changed, added or deleted, the hash changes, and the program will provide a notification. 

