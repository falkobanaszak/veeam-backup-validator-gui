# Veeam Backup Validator PowerShell GUI
This PowerShell GUI tool triggers the built-in Veeam.Backup.Validator.exe.

## Intro

It checks your backup files via CRC at the file level. For the integrity validation of your backups the Validator uses the checksum algorithm.

After each creation of a backup file, Veeam calculates a checksum for every data block in the backup file and will attach the checksums to them. The Veeam Backup Validator re-calculates the checksums for data blocks and compares them with the initial written values.

You can find the Veeam Backup Validator.exe file by default under

**%ProgramFiles%\Veeam\Backup and Replication\Backup\Veeam.Backup.Validator.exe**

You can find out more on the Veeam Backup Validator on these sites:

[Veeam Backup Validator - Veeam Helpcenter](https://helpcenter.veeam.com/docs/backup/vsphere/backup_validator.html?ver=95u4)
[How to use the Veeam Backup Validator with the cmd](https://www.veeam.com/kb2086)

The simple GUI looks like this:
![Veeam Backup Validator PowerShell GUI](https://github.com/falkobanaszak/veeam-backup-validator-gui/blob/master/PowerShellGUI.png)

In this first Version (Version 0.1) you are able to choose a .vbk or .vbm File for validation:

After choosing you can select whether you want to have a XML or a HTML Report:

The last step is to provide a directory for storing the generated Report through the Veeam Backup Validator .exe:

After you decided for a directory, the tool immediately starts to validate your backup files.
You can watch the process live, as the tools open up a Windows cmd where you can see the validation process:

After the process is finished, you can open up the report in your specified directory and check the validation process:

