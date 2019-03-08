<# 
.NAME
    Veeam Backup Validator PowerShell GUI
.SYNOPSIS
    Use this free tool to validate your Veeam Backups with the built-in Veeam.Backup.Validator.exe
.DESCRIPTION
    Released under the MIT license.
.LINK
    https://github.com/falkobanaszak
.VERSION
    0.1
#>

#region begin GLOBAL VARIABLES {
$Global:SelectedFile =$Null
$ValidatorPath = 'C:\Program Files\Veeam\Backup and Replication\Backup'
$InitialDirectory = [Environment]::GetFolderPath('Desktop')
#$ReportLocation="C:\Temp\"
$ReportName="Veeam-Backup-Validation-Report_$(get-date -f dd-MM-yyyy-hh-mm-ss)"
#endregion GLOBAL VARIABLES}


#region begin FUNCTIONS {

Function Choose-File($InitialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = "Veeam Backup File (*.vbk)|*.vbk|Veeam Backup Metadata File (*.vbm)|*.vbm"
    # Out-Null supresses the "OK" after selecting the file.
    $OpenFileDialog.ShowDialog() | Out-Null
    $Global:SelectedFile = $OpenFileDialog.FileName
}

Function Choose-Folder($InitialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $OpenFolderDialog.ShowDialog() | Out-Null
    $Global:SelectedFolder = $OpenFolderDialog.SelectedPath
}

#endregion FUNCTIONS}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
#Set-Location -Path 'C:\Program Files\Veeam\Backup and Replication\Backup'

#region begin VBVGUI{

$VBVGUI                          = New-Object System.Windows.Forms.Form
$VBVGUI.ClientSize               = '300,275'
$VBVGUI.text                     = "Veeam Backup Validator GUI"
$VBVGUI.TopMost                  = $false

$VBVGUIlblInfo                   = New-Object System.Windows.Forms.Label
$VBVGUIlblInfo.Text              = "Use this GUI to validate your Veeam Backups"
$VBVGUIlblInfo.AutoSize          = $true
$VBVGUIlblInfo.Location          = New-Object System.Drawing.Point(15,15)
$VBVGUIlblInfo.Font              = 'Microsoft Sans Serif,10'

$VBVGUIValidateButton            = New-Object System.Windows.Forms.Button
$VBVGUIValidateButton.text       = "Choose Folder and validate .vbk or .vbm"
$VBVGUIValidateButton.width      = 120
$VBVGUIValidateButton.height     = 40
$VBVGUIValidateButton.location   = New-Object System.Drawing.Point(90,155)

$VBVGUIChooseFile                = New-Object System.Windows.Forms.Button
$VBVGUIChooseFile.text           = "Choose .vbk or .vbm"
$VBVGUIChooseFile.width          = 120
$VBVGUIChooseFile.height         = 30
$VBVGUIChooseFile.location       = New-Object System.Drawing.Point(90,50)

$VBVGUIXMLReport                 = New-Object System.Windows.Forms.RadioButton
$VBVGUIXMLReport.text            = "Create XML Report"
$VBVGUIXMLReport.AutoSize        = $true
$VBVGUIXMLReport.width           = 104
$VBVGUIXMLReport.height          = 20
$VBVGUIXMLReport.location        = New-Object System.Drawing.Point(10,100)
$VBVGUIXMLReport.Font            = 'Microsoft Sans Serif,10'

$VBVGUIHTMLReport                = New-Object System.Windows.Forms.RadioButton
$VBVGUIHTMLReport.text           = "Create HTML Report"
$VBVGUIHTMLReport.AutoSize       = $true
$VBVGUIHTMLReport.width          = 104
$VBVGUIHTMLReport.height         = 20
$VBVGUIHTMLReport.location       = New-Object System.Drawing.Point(160,100)
$VBVGUIHTMLReport.Font           = 'Microsoft Sans Serif,10'
$VBVGUIHTMLReport.Checked        = $true

$VBVGUIDisclaimer                = New-Object System.Windows.Forms.Label
$VBVGUIDisclaimer.text           = "Copyright (c) 2019 Falko Banaszak`n`nDistributed under MIT license."
$VBVGUIDisclaimer.AutoSize       = $true
$VBVGUIDisclaimer.location       = New-Object System.Drawing.Point(35,200)
$VBVGUIDisclaimer.Font           = 'Microsoft Sans Serif,10'

#endregion VBVGUI}

$VBVGUIChooseFile.Add_Click({
Choose-File
[System.Windows.Forms.MessageBox]::Show("The following file has been selected: $Global:SelectedFile" , "Information", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
})

$VBVGUIValidateButton.Add_Click({
If ($Global:SelectedFile -eq $Null)
    {
        [System.Windows.Forms.MessageBox]::Show("No File Selected. Please select a file !", "Error", 0, [System.Windows.Forms.MessageBoxIcon]::Exclamation)
    }
else
    {

    IF ($VBVGUIXMLReport.Checked -eq "True")
        {
            Choose-Folder
            #$ReportString="$ReportLocation"+"$ReportName"+".xml"
            $ReportString="$Global:SelectedFolder"+"\"+"$ReportName"+".xml"
            Set-Location -path $ValidatorPath
            .\Veeam.Backup.Validator.exe /file:$Global:SelectedFile /report:$ReportString /format:xml
            [System.Windows.Forms.MessageBox]::Show("Validation process finished !" , "Information", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
            
        }
    Else
        {
            Choose-Folder
            #$ReportString="$ReportLocation"+"$ReportName"+".html"
            $ReportString="$Global:SelectedFolder"+"\"+"$ReportName"+".html"
            Set-Location -path $ValidatorPath
            .\Veeam.Backup.Validator.exe /file:$Global:SelectedFile /report:$ReportString
            [System.Windows.Forms.MessageBox]::Show("Validation process finished !" , "Information", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    }
})



$VBVGUI.Controls.AddRange(@($VBVGUIlblInfo,$VBVGUIValidateButton,$VBVGUIXMLReport,$VBVGUIHTMLReport,$VBVGUIDisclaimer,$VBVGUIChooseFile))
[void] $VBVGUI.ShowDialog()