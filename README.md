# SpoutSort
### v1.1.1
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

WARNING: the maths in this patch are very clunky and smelly so don't be surprised if you end up with ~8fps while running a 720p file.
Stick to using smaller files for now, also using higher sorting tresholds results in more fps.


![alt text](https://raw.githubusercontent.com/x-j/SpoutSort/master/img.png)

# dependencies
Depends on Processing Video and Spout libraries. Install both of them through Processing IDE by going: Tools -> Add Tool -> Libraries.

Of course, if you're a Mac user, you don't install the Spout library. You sit there in your comfortable chair and rethink all your lifechoices that lead you up to this single moment of you sitting there in your colorful shirt gaping pointlessly at your Retina$2200 display on a company-issued (c)MacBook(tm). Is this how you're planning to fight the global capitalism? Adding wacky video filters to it and pretending that we're making it more modern is just the same as when we celebrate with wine every time that some politician agrees to vote on a law that grants _a law_ to gay marriage. Ultimately these actions are feeding into the propaganda of an empowered establishment which bases their all decisions on statistical calculations made by some BigDataAnalyst that showed them on a nice vector boxplot that appealing is a _profitable decision_. If the _profitable decision_ would have been calculated to be siding with fascists then you bet that their strategy for the next Q will be dogwhistling and winking to fascists. And for many players it is more _profitable_ to side with the fascist voters. The unjust system is encourages this type of propaganda and manipulation techniques because it's about the _profit_, not the feelings of the opressed minorities that are benevolently shown support to increase their voting participation. It does not care about your feelings, or your fancy pixel sorters. Your labor in the field of wacky image manipulation serves ultimately only to increase the profits of the capitalist establishment and you are aware of it. Maybe you weren't when you took that job, but by now you've spent some time in this industry. You can feel that it's pointless unjust. The bad news is that by as long as you are participating in the unjust system, you are making it stronger. The twisted thing about all of this is that the system took everything from you, and then forced you to work for their sole profits just so you don't die. It's set it up like this for all of us, it's a dead end and you realize that just by sitting idly things can only get worse. When you don't act, the unjust system is getting stronger. That's why you should support your local open-source communities.

# usage as a standalone Processing Script 
You can have the SpoutSort directory anywhere and it should just work.

Find and run the script named __SpoutlessSort.pde__. It's a trimmed version of the main script that doesn't use Spout and so should work on Mac.

At startup, displays a File Opening dialog which prompts you to pick a video file.

PixelSorting is applied and the result is displayed in the script window. Also displayed in the script window are some debugging information.

The video will be played with sound, probably. Be wary of this, and if need be I suggest to use your Volume Mixer application of choice and mute the script window.

Alternativelly, if you're not using this as a Spout object, you can test out the parameters by pressing some keys:
- [1] to switch to brightness sorting mode. This mode generally looks best and works best.
- [2] to switch to white sorting mode. This mode generally just causes absolutely every pixel to get sorted and it all looks like a mess.
- [3] to switch to black sorting mode. This mode generally does nothing and what you get is just an unoptimised video player.
- [4] to switch t0 vertical sorting.
- [5] to switch to horizontal sorting.
- [6] to switch to diagonal sorting. Looks nice but is pretty slow.
- [-] to decrease threshold by 1
- [=] to increase threshold by 1
- [\_] or [Shift-] to decrease threshold by 10
- [+] or [Shift=] to increase threshold by 10
- [ to slow down video playback
- ] to speed up video playback
- [0] to enable/disable text debugging.
- [spacebar] to pause/unpause.
- [right mouse click on the video] to change the video.
- [Esc] to esc

Fun fact: also works on images!


# using as a SpoutControls sender

## __the following works on Windows only.__

Run the script named __SpoutSort.pde__. It should behave similarly to the behaviour described above.
 

The Spout object should be automatically initialised and be available to your Spout receivers. Will it work for sure? Who knows, Spout is a mystery. 

Fear not, debugging information is not transmitted through Spout.
Other apllications which use SpoutControls (like the FFGL plugin wrap discussed below) should be able to control the parameters of the sort: the direction, threshold and _mode_ of the sort. This disables the possibilty of controlling the script by keyboard but you can still right-click to change a video. Feel free to experiment with it if you manage to make SpoutControls to work!

# usage as an FFGL plugin
Create a copy of the main SpoutSort directory and paste in in your FFGL plugin folder of choice. Should just work.

# compatibility
- This is a 64bit program. May not work with your 32bit applications and will almost definitely not work as an FFGL plugin.

- SpoutlessSort.pde is Mac-compatible, other functionalities aren't.

- SpoutSort uses Processing 3.4 and I have no idea if it works with other versions. Let me know!

- SpoutSort uses Spout 2.006 and I have no idea if it works with other versions. Let me know!

- SpoutSort _should_ work with most video files. Which exactly? Who knows. MOV files generally don't work so well and DXV files may cause your computer to burst into flames. Don't say I didn't warn you.

- I've tested it out with Magic Music Visuals and OBS and it worked fine. Theoretically should work in Resolume and elsewhere too. Let me know!

# known errors
You may experience the following:

- random crashes. Oh, the joy that is Processing!
- the file selection dialog may appear _behind_ the window of the application. Drag it around and look for it! It's a treasure hunt!

![twuj stary](https://i.ibb.co/zPwwrp8/twuj-stary.png)

# changelog

## [1.1.0] - 2019-04-07

Some responded that they were having troubles with using this as an FFGL plugin in Resolume. You may be happy to hear that I found a possible culprit, but you won't be happy to hear that: it's most probably SpoutControls at fault here. I suggest that after you download the new version, use the procedure described in [the greatest tutorial I've ever read by Eric Medine](http://ericmedine.com/spout-controller-for-resolume/) and re-deploy my script on your machine. yay, bug fixes!

also the new version contains a new feature that lets you speed up and slow down videos ･'(*⌒―⌒*))) try it!

### 1.0

no-man's land but for all we knew it worked!


# Licence
this uses GPL3 but in general please don't be a jerk and support your local open-source community.
