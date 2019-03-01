# gamesense
Gamesense lua scripts

## Getting Started
### Installing
Inside Windows PowerShell locate the path where you want to temporarily store project and enter...
```
git clone https://git.pngamers.org/w7rus/gamesense.git
```
![](https://i.imgur.com/XnJ2CFt.jpg)

Now that you downloaded/cloned this project, run installation of required dependencies...
```
cd gamesense
./depGet.ps1
```
![](https://i.imgur.com/LeVfXpJ.jpg)

### Configure
1. Open scripts file and edit __`[Configuration]`__ block code
2. If it's said __`["Do not edit below this line"]`__ then don't edit anything below it

### Linking
#### Method 1
* Copy all contents of `scripts` folder to game's root directory `...\steamapps\common\Counter-Strike Global Offensive`
![](https://i.imgur.com/bXW1rK4.jpg)
#### Method 2
* Copy `scripts\csgo` folder to game's root directory `...\steamapps\common\Counter-Strike Global Offensive`.
* Create for each script file symlinks to game's root directory `...\steamapps\common\Counter-Strike Global Offensive`
[Symlinker](https://github.com/amd989/Symlinker)

## Usage
* Open lua manager and load files starting with __`script_`__
