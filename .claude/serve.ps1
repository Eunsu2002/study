$root = Split-Path -Parent $PSScriptRoot
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8765/")
$listener.Start()
Write-Host "Serving $root at http://localhost:8765/"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  try {
    $path = [System.Uri]::UnescapeDataString($ctx.Request.Url.LocalPath).TrimStart('/')
    if ([string]::IsNullOrEmpty($path)) { $path = 'index.html' }
    $file = Join-Path $root $path
    $fullFile = [System.IO.Path]::GetFullPath($file)
    if ($fullFile.StartsWith($root) -and (Test-Path $fullFile -PathType Leaf)) {
      $bytes = [System.IO.File]::ReadAllBytes($fullFile)
      $ext = [System.IO.Path]::GetExtension($fullFile).ToLower()
      $ct = switch ($ext) {
        '.html' { 'text/html; charset=utf-8' }
        '.js'   { 'text/javascript; charset=utf-8' }
        '.css'  { 'text/css; charset=utf-8' }
        '.json' { 'application/json; charset=utf-8' }
        '.png'  { 'image/png' }
        '.jpg'  { 'image/jpeg' }
        '.ico'  { 'image/x-icon' }
        '.svg'  { 'image/svg+xml' }
        default { 'application/octet-stream' }
      }
      $ctx.Response.ContentType = $ct
      $ctx.Response.ContentLength64 = $bytes.Length
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
    }
  } catch {
    try { $ctx.Response.StatusCode = 500 } catch {}
  }
  $ctx.Response.Close()
}
