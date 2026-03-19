param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('Ping', 'HasImage', 'DumpPngBase64', 'GetText')]
  [string] $Action
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-ClipboardFileDropPath {
  try {
    $files = [Windows.Forms.Clipboard]::GetFileDropList()
    if ($files -and $files.Count -gt 0) {
      return $files[0]
    }
  } catch {
  }

  return $null
}

function Get-ClipboardImageObject {
  try {
    return Get-Clipboard -Format Image
  } catch {
    return $null
  }
}

function Get-ImageFromFile([string] $Path) {
  if ([string]::IsNullOrWhiteSpace($Path)) {
    return $null
  }

  if (-not (Test-Path -LiteralPath $Path)) {
    return $null
  }

  try {
    return [System.Drawing.Image]::FromFile($Path)
  } catch {
    return $null
  }
}

function Write-ImageAsPngBase64([System.Drawing.Image] $Image) {
  if ($null -eq $Image) {
    exit 1
  }

  $stream = New-Object System.IO.MemoryStream
  try {
    $Image.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
    [Convert]::ToBase64String($stream.ToArray())
    exit 0
  } finally {
    $stream.Dispose()
    $Image.Dispose()
  }
}

switch ($Action) {
  'Ping' {
    Write-Output 'ok'
    exit 0
  }

  'HasImage' {
    $file = Get-ClipboardFileDropPath
    if ($file) {
      $fileImage = Get-ImageFromFile $file
      if ($fileImage) {
        $fileImage.Dispose()
        Write-Output 'image/png'
        exit 0
      }
    }

    $clipboardImage = Get-ClipboardImageObject
    if ($clipboardImage) {
      $clipboardImage.Dispose()
      Write-Output 'image/png'
      exit 0
    }

    exit 1
  }

  'DumpPngBase64' {
    $file = Get-ClipboardFileDropPath
    if ($file) {
      $fileImage = Get-ImageFromFile $file
      if ($fileImage) {
        Write-ImageAsPngBase64 $fileImage
      }
    }

    $clipboardImage = Get-ClipboardImageObject
    if ($clipboardImage) {
      Write-ImageAsPngBase64 $clipboardImage
    }

    exit 1
  }

  'GetText' {
    $file = Get-ClipboardFileDropPath
    if ($file) {
      Write-Output $file
      exit 0
    }

    try {
      $text = Get-Clipboard
    } catch {
      $text = $null
    }

    if ($null -eq $text) {
      exit 1
    }

    Write-Output $text
    exit 0
  }
}
