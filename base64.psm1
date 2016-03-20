function tobase64($tr)
{ $tr=[System.Text.Encoding]::UTF8.GetBytes($tr)
[System.Convert]::ToBase64String($tr)
}
function frombase64($ba){
$ba=[System.Convert]::FromBase64String($ba)
[System.Text.Encoding]::UTF8.GetString($ba)
}


