param ($GameDir, $ProjectName = "SystemEx")

$StageDir = "build/package"
$Version = & $($PSScriptRoot + "\steps\get-version.ps1")

& $($PSScriptRoot + "\steps\compose-redscripts.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -Version ${Version}
& $($PSScriptRoot + "\steps\compose-hints.ps1") -StageDir ${StageDir}
& $($PSScriptRoot + "\steps\install-from-stage.ps1") -StageDir ${StageDir} -GameDir ${GameDir}

Remove-Item -Recurse ${StageDir}
