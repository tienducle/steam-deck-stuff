# Steam Deck - Personal collection of useful stuff

## General

### SSH

[Wiki](https://github.com/tienducle/steam-deck-stuff/wiki/SSH)

### Steam Link

With the Steam Link app, you can remotely connect to your Steam Deck and control it from your device.

- On the Steam Deck, open the **Settings** and open **Remote Play**

- Enable Remote Play

- Get the [Steam Link app](https://store.steampowered.com/remoteplay#anywhere) on your computer/device

- Open the Steam Link app and start the pairing process

- Enter the PIN shown on your device into your Steam Deck

If the steps above do not work because the Steam Deck can not be found:

- On the Steam Deck, open the **Settings** and open **Remote Play** and tap on **Pair Steam Link**

- In Steam Link, tap on **Other Computer**

- Enter the PIN shown on your device into your Steam Deck

### Proton GE

Custom build of Proton including experimental features. (see [Project repo](https://github.com/GloriousEggroll/proton-ge-custom))

This [script](./src/protonge.sh) installs the latest Proton GE release. On re-running it will also update to the latest release. By default, it will keep 5 most recent versions installed.

#### Usage

- Switch to Desktop mode

- Open the terminal and run the following command

```bash
bash <(curl -s https://raw.githubusercontent.com/tienducle/steam-deck-stuff/main/src/protonge.sh)
```

- Switch back to Gaming mode

- Open the Settings of a game and check for Proton GE under the compatibility settings

- Optional: Add `DXVK_ASYNC=1` to launch options of a game if desired.

## Cloud Gaming

[Xbox Cloud Gaming](https://support.microsoft.com/en-us/topic/xbox-cloud-gaming-in-microsoft-edge-with-steam-deck-43dd011b-0ce8-4810-8302-965be6d53296)

## Emulation - RetroArch

[Core Updater](https://github.com/lajoshanostra/Steam-Deck-RA-Core-Updater)
