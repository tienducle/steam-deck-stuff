#!/bin/bash

# The script will keep this max number of Proton GE versions. Older versions (determined by folder's last modified timestamp) will be deleted.
MAX_NUMBER_OF_VERSIONS_INSTALLED=100

# Keep downloaded .tar.gz asset
KEEP_DOWNLOADED_ASSET=false

# URL of Proton GE latest release
if [[ -z "$1" ]]; then
  LATEST_RELEASE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
else
  LATEST_RELEASE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/$1"
fi

# Target folder to extract Proton GE into
TARGET_FOLDER=$(eval echo "~/.steam/root/compatibilitytools.d")

# Get release details
echo "Getting release details from $LATEST_RELEASE_URL.."
LATEST_RELEASE_JSON=$(curl $LATEST_RELEASE_URL)

# Get assets of release
ASSETS_COUNT=$(jq '.["assets"] | length' <<< "$LATEST_RELEASE_JSON")

# Find the tar.gz release asset
for (( i=0; i<$ASSETS_COUNT; i++ ))
do
	ASSET_NAME=$(jq --arg index "$i" '.["assets"][$index|tonumber] | select(.name | endswith(".tar.gz")) | .name' <<< "$LATEST_RELEASE_JSON" | tr -d \")
	ASSET_ID=$(jq --arg index "$i" '.["assets"][$index|tonumber] | select(.name | endswith(".tar.gz")) | .id' <<< "$LATEST_RELEASE_JSON")
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
else
	echo "$ASSET_NAME is already installed."
#	exit 1;
fi

# Cleanup of old versions
echo "Cleanup and keeping $MAX_NUMBER_OF_VERSIONS_INSTALLED latest Proton GE versions.."
i=0
for folder in $TARGET_FOLDER/*; do
	i=$((i+1))
	if (( $i < $MAX_NUMBER_OF_VERSIONS_INSTALLED ));
	then
		echo "Keeping $folder"
		continue
	fi
	echo "Removing $folder.."
#	rm -rf "$file"	
done

echo "Done"
