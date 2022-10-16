# The Dark Pictures Anthology - Man of Medan

[Source](https://gist.github.com/AwesamLinux/c6ed174ee91415d3983cb91fabd27b35)

# Instructions

- Copy the fix-videos.sh file to "(...)/steamapps/common/The Dark Pictures Anthology - Man of Medan/" directory
	- `cp fix-videos.sh "/run/media/mmcblk0p1/steamapps/common/The Dark Pictures Anthology - Man of Medan/"`
- Switch to game directory
	- `cd "/run/media/mmcblk0p1/steamapps/common/The Dark Pictures Anthology - Man of Medan/"`
- Make the fix-videos.sh file executable
	- `chmod +x fix-videos.sh`
- Execute script
	- `./fix-videos.sh`
	- This will take a few minutes
	- When done, you will see that the broken videos have been replaced and the old ones have been renamed to something.bak. And the fixed videos will play with VLC (the old ones didn't)
