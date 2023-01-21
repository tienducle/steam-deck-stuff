#!/bin/bash
TARGET_FOLDER=/home/deck/apps/PokeMMO
ARCHIVE_URI=https://dl.pokemmo.com/download/PokeMMO-Client.zip
JRE_ARCHIVE=zulu17.40.19-ca-jre17.0.6-linux_x64

JRE_BASE_PATH=https://cdn.azul.com/zulu/bin/
JRE_ARCHIVE_URI="$JRE_BASE_PATH$JRE_ARCHIVE.zip"

downloadPokemmo()
{
	echo "Downloading PokeMMO-Client.."
  curl "$ARCHIVE_URI" --output pokemmo.zip
}

downloadJre()
{
	echo "Downloading JRE.."
	curl "$JRE_ARCHIVE_URI" --output jre.zip
}

if [ -d "$TARGET_FOLDER" ]; then
	echo "It seems that PokeMMO is already installed."
	read -p "Proceed and re-install? (y/n)" yn
	case $yn in 
			yes ) echo "OK";;
			* ) echo "Exiting.."; exit;;
	esac
fi

if ! [[ -x "$(command -v curl)" ]]; then
  echo "Error: curl is not installed."
  exit -1
fi

if [ ! -d "$TARGET_FOLDER" ]; then
	mkdir -p "$TARGET_FOLDER"
	mkdir -p "$TARGET_FOLDER/jre"
	downloadJre
	unzip -o jre.zip -d "$TARGET_FOLDER/jre"
	mv "$TARGET_FOLDER/jre/$JRE_ARCHIVE" "$TARGET_FOLDER/jre/zulu17"
	rm -rf jre.zip
fi

downloadPokemmo
unzip -o pokemmo.zip -d "$TARGET_FOLDER"
rm -rf pokemmo.zip

sed -i "/^java .*/i export PATH=$TARGET_FOLDER/jre/zulu17/bin:\$PATH" "$TARGET_FOLDER/PokeMMO.sh"
chmod +x "$TARGET_FOLDER/PokeMMO.sh"

echo "PokeMMO installed."
read -p "Press enter to open $TARGET_FOLDER, then right-click on PokeMMO.sh and click on 'Add to Steam'"
dolphin "$TARGET_FOLDER" &