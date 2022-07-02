#!/bin/bash

# The script will keep this max number of Proton GE versions. Older versions (determined by folder's last modified timestamp) will be deleted.
MAX_NUMBER_OF_VERSIONS_INSTALLED=5

# Keep downloaded .tar.gz asset
KEEP_DOWNLOADED_ASSET=false

# URL of Proton GE releases
RELEASES_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases"

# Target folder to extract Proton GE into
TARGET_FOLDER=$(eval echo "~/.steam/root/compatibilitytools.d")

# Get the list of releases (newest first)
echo "Getting releases from $RELEASES_URL.."
RELEASES=$(curl $RELEASES_URL)

# Get assets of first (most recent) release
ASSETS=$(jq '.[0]["assets"] | length' <<< "$RELEASES")

# Find the tar.gz release asset
for (( i=0; i<$ASSETS; i++ ))
do
	ASSET_NAME=$(jq --arg index "$i" '.[0]["assets"][$index|tonumber] | select(.name | endswith(".tar.gz")) | .name' <<< "$RELEASES" | tr -d \")
	ASSET_ID=$(jq --arg index "$i" '.[0]["assets"][$index|tonumber] | select(.name | endswith(".tar.gz")) | .id' <<< "$RELEASES")
done

# If the asset was found, check if the current version is up-to-date
if [ -z "$ASSET_NAME" ]
then
	echo "No tar.gz asset found"
	exit 1;
else
	ALREADY_DOWNLOADED=$(find $TARGET_FOLDER -name "${ASSET_NAME%.tar.gz}")
fi

# Download the new version if it's not installed yet
if [ -z "$ALREADY_DOWNLOADED" ]
then
	echo $ALREADY_DOWNLOADED
	echo "Downloading $ASSET_NAME.."
	curl -L -H "Accept: application/octet-stream" "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/assets/$ASSET_ID" -o "$ASSET_NAME"
else
	echo "Latest version is already installed."
	exit 1;
fi

# Extract
echo "Extracting to ~/.steam/root/compatibilitytools.d/"
mkdir -p ~/.steam/root/compatibilitytools.d
tar -xf "$ASSET_NAME" -C ~/.steam/root/compatibilitytools.d/

# Delete downloaded asset if enabled
if ! $KEEP_DOWNLOADED_ASSET
then
	echo "Deleting downloaded asset $ASSET_NAME.."
	rm -rf $ASSET_NAME
fi

# Cleanup of old versions
echo "Cleanup and keeping $MAX_NUMBER_OF_VERSIONS_INSTALLED latest Proton GE versions.."
INSTALLED=$(ls -t $TARGET_FOLDER | grep GE-Proton)
declare -a INSTALLED_LIST=($(echo $INSTALLED | tr ", " " "))
for (( i=0; i<${#INSTALLED_LIST[@]}; i++ ))
do
	if [[  $i < 5 ]]
	then
		continue
	fi
	ITEM=${INSTALLED_LIST[$i]}
	echo "Removing $ITEM.."
	rm -rf "$TARGET_FOLDER/$ITEM"
done

echo "Done"
