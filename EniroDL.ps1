<#
	.SYNOPSIS
	Download a chunk of map from Eniro.

	.PARAMETER URL
	A Eniro URL to a point on the map.
	Example: https://kartor.eniro.se/?c=57.611808,11.771765&z=14&l=nautical
	.PARAMETER Latitude
	The latitude for the center of the map.
	.PARAMETER Longitude
	The longitude for the center of the map.
	.PARAMETER X
	The x-position of the center tile.
	.PARAMETER Y
	The y-position of the center tile.
	.PARAMETER Zoom
	The zoom level.
	.PARAMETER Type
	The map type to download.
	The different types are: map, nautical, aerial, and historic.
	.PARAMETER Side
	The number of tiles at the side of the map.
	.PARAMETER Out
	The output directory.
#>

[CmdletBinding(
	DefaultParameterSetName = "latlon"
)]
param (
	[Parameter(
		Mandatory = $true,
		ValueFromPipeline = $true,
		Position = 0,
		ParameterSetName = "url"
	)]
	[ValidatePattern("c=\d+(\.\d+),\d+(\.\d+)")]
	[ValidatePattern("z=\d+")]
	[string]
	$URL,

	[Parameter(
		Mandatory = $true,
		Position = 0,
		ParameterSetName = "latlon"
	)]
	[Alias("Lat")]
	[double]
	$Latitude,
	[Parameter(
		Mandatory = $true,
		Position = 1,
		ParameterSetName = "latlon"
	)]
	[Alias("Lon")]
	[double]
	$Longitude,

	[Parameter(
		Mandatory = $true,
		ParameterSetName = "tile"
	)]
	[int]
	$X,
	[Parameter(
		Mandatory = $true,
		ParameterSetName = "tile"
	)]
	[int]
	$Y,

	[Parameter(
		Mandatory = $true,
		Position = 2,
		ParameterSetName = "latlon"
	)]
	[Parameter(
		Mandatory = $true,
		Position = 2,
		ParameterSetName = "tile"
	)]
	[int]
	$Zoom,
	[ValidateSet("map", "nautical", "aerial", "historic")]
	[Alias("T")]
	[string]
	$Type = "nautical",
	[int]
	[Alias("S")]
	$Side = 9,
	[string]
	[Alias("O")]
	$Out = "Out"
)

function LonToX([double] $lon) {
	return [Math]::Floor(($lon + 180) / 360 * [Math]::Pow(2, $Zoom))
}
function LatToY([double] $lat) {
	return [Math]::Pow(2, $Zoom) - [Math]::Floor((1 - [Math]::Log([Math]::Tan($lat * [Math]::PI / 180) + 1 / [Math]::Cos($lat * [Math]::PI / 180)) / [Math]::PI) / 2 * [Math]::Pow(2, $Zoom)) - 1
}

if ($PSCmdlet.ParameterSetName -eq "url") {
	$URL -match "z=(\d+)" | Out-Null
	$Zoom = ($Matches[1] / 1)

	$URL -match "c=(\d+(?:\.\d+)),(\d+(?:\.\d+))" | Out-Null
	$X = LonToX ($Matches[2] / 1.0)
	$Y = LatToY ($Matches[1] / 1.0)

	if (!$PSBoundParameters.ContainsKey("Type") -and $URL -match "l=(\w+)") {
		$Type = $Matches[1]
	}
}
elseif ($PSCmdlet.ParameterSetName -eq "latlon") {
	$X = LonToX $Longitude
	$Y = LatToY $Latitude
}

$OutTiles = Join-Path $Out "Tiles"

if (!(Test-Path $OutTiles)) {
	New-Item -ItemType Directory -Path $OutTiles -Force | Out-Null
}

$ImageType = @{
	"map"      = "png"
	"nautical" = "png"
	"aerial"   = "jpeg"
	"historic" = "jpeg"
}[$Type]
$MapLayer = @{
	"map"      = "map"
	"nautical" = "nautical"
	"aerial"   = "aerial"
	"historic" = "se_aerial_1950_60s"
}[$Type]

$Urls = @()
for ($yy = [Math]::Floor($Y + $Side / 2); $yy -ge [Math]::Floor($Y - $Side / 2) + 1; $yy--) {
	for ($xx = [Math]::Floor($X - $Side / 2) + 1; $xx -le [Math]::Floor($X + $Side / 2); $xx++) {
		$Urls += @{
			Uri      = "https://map04.eniro.no/geowebcache/service/tms1.0.0/$MapLayer/$Zoom/$xx/$yy.$ImageType"
			FileName = Join-Path $OutTiles "$Type-$Zoom-$xx-$yy.$ImageType"
		}
	}
}

$Urls | ForEach-Object -Parallel {
	if (!(Test-Path $_.FileName)) {
		Invoke-WebRequest -Uri $_.Uri -OutFile $_.FileName
	}
}

Start-Process ".\ImageMagick\montage" "-tile $($Side)x$($Side) -geometry +0+0 $($Urls | Join-String -Separator " " -Property "FileName") $(Join-Path $Out "Map.png")" -NoNewWindow