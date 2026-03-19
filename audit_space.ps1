$sizes = @{}

function Get-FolderSize {
    param($Path)
    if (Test-Path $Path) {
        $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        if ($null -eq $size) { return 0 }
        return [math]::Round($size / 1MB, 2)
    }
    return 0
}

$sizes['weesh_mobile_build'] = Get-FolderSize 'c:\p-t-o\weesh_mobile\build'
$sizes['weesh_driver_build'] = Get-FolderSize 'c:\p-t-o\weesh_driver\build'
$sizes['gradle_caches'] = Get-FolderSize 'C:\Users\zen-0\.gradle\caches'
$sizes['gradle_wrapper'] = Get-FolderSize 'C:\Users\zen-0\.gradle\wrapper\dists'
$sizes['pub_cache'] = Get-FolderSize 'C:\Users\zen-0\AppData\Local\Pub\Cache'

$sizes | ConvertTo-Json
