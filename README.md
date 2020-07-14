# EniroDL

A command-line tool for downloading maps from [Eniro.se](https://eniro.se/)

## Before using

Download a portable version of ImageMagic from [here](https://imagemagick.org/script/download.php)
and extract it in to `.\ImageMagick\`

## Usage

Call `.\EniroDL.ps1` with the first two arguments being the x- and y-position of
the desired center tile and the third argument the zoom level.

Optional arguments are `-Out` for specifying the output directory (default is
`.\Out`), and `-Side` for specifying how many tiles wide the map should be
(default is 9).

### Examples

Quick and easy:
```PowerShell
.\EniroDL.ps1 8727 11416 14
```

All arguments explicitly:
```PowerShell
.\EniroDL.ps1 -X 8727 -Y 11416 -Zoom 14 -Side 4 -Out .
```

Full power and simple:
```PowerShell
.\EniroDL.ps1 8727 11416 14 -S 4 -O .
```