#######################################
# SCRIPT TO DECODE BASE64 STRINGS     #
# VERSION - 0.1                       #
# AUTHOR - Arun k Singh               #
#######################################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$DateFormat = "yyyy-MM-dd HH:mm:ss"
$Date = [DateTime]::Now.ToString($dateFormat)
# create an instance of the Form class
$form = New-Object System.Windows.Forms.Form
$form.Text = 'BASE64 ENCODE - DECODE'
$form.Size = New-Object System.Drawing.Size(700,400)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(200,220)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'DECODE'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(350,220)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'ENCODE'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = $Date
$form.Controls.Add($label1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,50)
$label2.Size = New-Object System.Drawing.Size(680,40)
$label2.Text = 'PLACE STRING DATA IN TEXT BOX AND CLICK ON BUTTON, YOUR ENCR/DECR STRING WILL COPIED IN CLIPBOARD. PASTE IT ON NOTEPAD TO SEE THE VALUE'
$form.Controls.Add($label2)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,100)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the string in the space below:'
$form.Controls.Add($label)


$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,140)
$textBox.Size = New-Object System.Drawing.Size(660,75)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox.Text

    $DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($x))

    $DecodedText | Clip
    # because of security i am not printing the output is copied in clip board, you just paste it anywhere. 

}

if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    $x = $textBox.Text

    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($x)
    $EncodedText =[Convert]::ToBase64String($Bytes)

    $EncodedText | Clip
    # because of security i am not printing the output is copied in clip board, you just paste it anywhere. 

}   
