# SpoutSort
simple Processing patch + SpoutControls FFGL plugin for PixelSorting local videos

![alt text](http://www.sweetbrokacik.pl/duze/powitalnia.gif)


# what is?
Everybody likes PixelSorting. Makes me feel like I'm back in 2018 again.
This patch does the following:
1. asks you to provide a local video file
2. applies PixelSorting to this video file
3. you can kinda control the direction and intensity of the effect, and the _type_ of the sort technique (but this works terribly)
4. this script is a SpoutControls sender which means you can use it together with your other Spout applications + additional bonus if you happen to know how to use SpoutControls
5. this whole thing should also be usable as an FFGL plugin which is nice

WARNING: the maths in this patch are very clunky as smelly so don't be surprised if you end up with ~8fps while running a 720p file.
Stick to using smaller files for now.

![alt text](https://raw.githubusercontent.com/x-j/SpoutSort/master/img.png)

# usage as a standalone Processing Script / SpoutControls sender
You can have the SpoutSort directory anywhere and it should just work.

At startup, displays a File Opening dialog which prompts you to pick a video file.

PixelSorting is applied and the result is displayed in the script window. Also displayed in the script window are some debugging information but! Fear not, this debugging information is turned off when streaming through Spout.

The video will be played with sound, probably. Be wary of this, and if need be I suggest to use your Volume Mixer application of choice and mute the script window.

The Spout object should be automatically initialised and be available to your Spout receivers. Will it work for sure? Who knows, Spout is a mystery.

Other apllications which use SpoutControls (like the FFGL plugin wrap discussed below) should be able to control the parameters of the sort: the direction, threshold and _mode_ of the sort. Feel free to experiment with it if you manage to make SpoutControls to work!

_
Alternativelly, if you're not using this as a Spout object, you can test out the parameters by pressing some keys:
- [1] to switch to brightness sorting mode. This mode generally looks best and works best.
- [2] to switch to white sorting mode. This mode generally just causes absolutely every pixel to get sorted and it all looks like a mess.
- [3] to switch to black sorting mode. This mode generally does nothing and what you get is just an unoptimised video player.
- [4] to switch t0 vertical sorting.
- [5] to switch to horizontal sorting.
- [6] to switch to diagonal sorting. Looks nice but is pretty slow.
- [0] to enable/disable text debugging.
- [spacebar] to pause/unpause.
- [right mouse click on the video] to change the video.
- [Esc] to esc

Fun fact: also works on images!

# usage as an FFGL plugin
Create a copy of the main SpoutSort directory and paste in in your FFGL plugin folder of choice. Should just work.

# compatibility
- This is a 64bit program. May not work with your 32bit applications and will almost definitely not work as an FFGL plugin.

- SpoutSort uses Processing 3.4 and I have no idea if it works with other versions. Let me know!

- SpoutSort uses Spout 2.006 and I have no idea if it works with other versions. Let me know!

- SpoutSort _should_ work with most video files. Which exactly? Who knows. MOV files generally don't work so well and DXV files may cause your computer to burst into flames. Don't say I didn't warn you.

- I've tested it out with Magic Music Visuals and OBS and it worked fine. Theoretically should work in Resolume and elsewhere too. Let me know!

# known errors
You may experience the following
- random crashes. Oh, the joy that is Processing!

![bottom business](https://unsee.cc/a186d6cc/)


# Licence
this uses GPL3 but in general please don't be a jerk and support your local open-source community.
