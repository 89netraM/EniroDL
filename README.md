# EniroDL

A command-line tool for downloading maps from [Eniro.se](https://eniro.se/)

## Before using

Download a portable version of ImageMagic from [here](https://imagemagick.org/script/download.php)
and extract it in to `.\ImageMagick\`

## Usage

Call `.\EniroDL.ps1` with the first two arguments being the x- and y-position of
the desired center tile and the third argument the zoom level. More [arguments](#Arguments)
are available below for more specific needs.

### Examples

Quick and easy:
```PowerShell
.\EniroDL.ps1 8727 11416 14
```

All arguments explicitly:
```PowerShell
.\EniroDL.ps1 -X 8727 -Y 11416 -Zoom 14 -Side 4 -Type aerial -Out .
```

Full power and simple:
```PowerShell
.\EniroDL.ps1 8727 11416 14 -S 4 -O .
```

### Arguments

**`-X`** <small>(Mandatory)</small>  
The x-position of the center tile.

**`-Y`** <small>(Mandatory)</small>  
The y-position of the center tile.

**`-Zoom`** <small>(Mandatory)</small>  
The zoom level.

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