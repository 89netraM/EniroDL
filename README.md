# EniroDL

A command-line tool for downloading maps from [Eniro.se](https://eniro.se/)

## Before using

Download a portable version of ImageMagic from [here](https://imagemagick.org/script/download.php)
and extract it in to `.\ImageMagick\`

## Usage

Call `.\EniroDL.ps1` with the first two arguments being the latitude and
longitude for the center of the map and the third argument the zoom level. More
[arguments](#Arguments) are available below for more specific needs.

### Examples

Quick and easy:
```PowerShell
.\EniroDL.ps1 57.611808 11.771765 14
```

All arguments explicitly:
```PowerShell
.\EniroDL.ps1 -Lat 57.611808 -Lon 11.771765 -Zoom 14 -Side 4 -Type aerial -Out .
```

Full power and simple:
```PowerShell
.\EniroDL.ps1 57.611808 11.771765 14 -S 4 -O .
```

### Arguments

**Coordinates**  
Either use `-Lat` and `-Lon` **or** `-X` and `-Y`

**`-Lat`** <small>(Mandatory)</small>  
The latitude for the center of the map.  
Can be deduced from position.

**`-Lon`** <small>(Mandatory)</small>  
The longitude for the center of the map.  
Can be deduced from position.

**`-X`** <small>(Mandatory)</small>  
The x-position of the center tile.

**`-Y`** <small>(Mandatory)</small>  
The y-position of the center tile.

**`-Zoom`** <small>(Mandatory)</small>  
The zoom level.  
Can be deduced from position.

**`-Type`**  
The map type to download.  
The different types are: "map", "nautical", "aerial", and "historic".  
**Default:** "nautical"

**`-Side`**  
The number of tiles at the side of the map.  
**Default:** `9`

**`-Out`**  
The output directory.  
**Default:** `.\Out\`