## About
 Fork to space. VGDC Winter '24. What more is there to say.

## Hotkeys

#### movement

 * WASD -- Move the player
 * Space -- Jump (or double-jump, if in the air)
 * Shift -- Dash

#### saving and loading 
NOTE: (all of these are debug inputs... the game will ideally save & load when you exit the game)
 * L -- Load Last Save
 * K -- Save
 * J -- Clear the screen of any blocks.

#### inventory system

 * E -- Open the inventory
 * RMB -- pick / drop an item
 * LMB -- pick up / drop a split stack (take / leave half the stack)

## Notes For Programmers
 Hi hi, it's [Gavin](https://github.com/gavindg). Here are a few standards for working on this repo / generally useful information for you programmer folk:

 * This project is built with Godot 4.2.1. If you don't have that installed, get it [here](https://godotengine.org/).
 * If you're using a JetBrains IDE or any other environment that creates files in the project folder, please add those to the gitignore. It's okay to commit gitignore changes to main, as long as you aren't doing weird stuff like removing other peoples lines.
 * If you're having trouble with this repository (like you don't have write access or something), please let me know and I'll try to get that fixed for you. 
 * If you guys are having trouble with git (like you've never used it before & don't know what to do), feel free to ask me any questions on discord and I'd be happy to help. [Pro Git](https://git-scm.com/book/en/v2) and the documentation from the same site is a great resource as well if you'd rather read, but its more of a command-line git thing. still useful for understanding the fundamentals of git though
 * Do not commit features directly to main, or really anything to be safe. If it's something small like a README change, that's ok... but as a general rule of thumb do any in-engine work on your own feature branch. Even for some small things, I'd prefer if you made a hotfix branch & did a quick PR, plus it inflates your contribution history yayyy green bubbles
 * I'm probably not going to bother restricting pull requests to only be approvable by me, but preferably don't pull your own changes into main without checking with other people first. Like, if you're working in a discord call w a bunch of people from the team and I'm not there and they all need your changes, feel free to pull w/o asking me. just dont break anything T-T
 * I encourage you guys to work together on features, but also please be safe about it. Work on your own branch unless you're collaborating with someone else on a feature and are communicating with them about what files to touch and which to leave alone.
 * I'm not sure how bad it is in Godot, but fixing merge conflicts on Unity scene files is a pretty major pain. To be safe, alongside working on your own git branch, please also work on your own scene in Godot.
 * do not commit curses or otherwise dark evil wizard code

 Ok I think that's everything. if we have any git bros out there w/ suggestions for this README lemme know. Once we get closer to playtest night, I'm gonna archive this guy and switch it out for an informational readme about the game. happy coding :^)
