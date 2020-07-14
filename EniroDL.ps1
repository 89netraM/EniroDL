<#
	.SYNOPSIS
	Download a chunk of map from Eniro.

	.PARAMETER X
	The x-position of the center tile.
	.PARAMETER Y
	The y-position of the center tile.
	.PARAMETER Zoom
	The zoom level.
	.PARAMETER Side
	The number of tiles at the side of the map.
	.PARAMETER Out
	The output directory.
#>

param (
	[Parameter(
		Mandatory = $true,
		Position = 0)]
	[int]
	$X,
	[Parameter(
		Mandatory = $true,
		Position = 1
	)]
	[int]
	$Y,
	[Parameter(
		Mandatory = $true,
		Position = 2
	)]
	[int]
	$Zoom,
	[int]
	[Alias("S")]
	$Side = 9,
	[string]
	[Alias("O")]
	$Out = "Out"
)

$OutTiles = Join-Path $Out "Tiles"

if (!(Test-Path $OutTiles)) {
	New-Item -ItemType Directory -Path $OutTiles -Force | Out-Null
}

$Urls = @()
for ($yy = [Math]::Floor($Y + $Side / 2); $yy -ge [Math]::Floor($Y - $Side / 2) + 1; $yy--) {
	for ($xx = [Math]::Floor($X - $Side / 2) + 1; $xx -le [Math]::Floor($X + $Side / 2); $xx++) {
		$Urls += @{
			Uri      = "https://map04.eniro.no/geowebcache/service/tms1.0.0/nautical/$Zoom/$xx/$yy.png"
			FileName = Join-Path $OutTiles "$Zoom-$xx-$yy.png"
		}
	}
}

$Urls | ForEach-Object -Parallel {
	if (!(Test-Path $_.FileName)) {
		Invoke-WebRequest -Uri $_.Uri -OutFile $_.FileName
	}
}

Start-Process ".\ImageMagick\montage" "-tile $($Side)x$($Side) -geometry +0+0 $($Urls | Join-String -Separator " " -Property "FileName") $(Join-Path $Out "Map.png")" -NoNewWindow