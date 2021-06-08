### Changes added in TinkerOS 5.06.3:

#### Documentation changes:
 - Classes are now clickable links

#### Code changes:
 - Fixed multiple inclusion of many find functions
 - Minor code cleanup
 - Updated Terry's old USB code scrap and broke it up into an initial kernel integration and demo application. Note don't get excited, there is no USB device support, only support to detect the UHCI USB Hosts for some Intel USB controllers. Mainly this has been added in case anyone wants to expand the feature out more or tinker with it. For an example see (QEMU/README.md)

### Changes added in TinkerOS 5.06.3:
- Fix and simplify new serial functions
- Minor documentation fixes

### Changes added in TinkerOS 5.06.2:
- Improved documentation, now global variable symbols, ASM symbols, and defined constants are now links. Also fixed documentation containing symbols which are the same color as the background for examples see <a href="https://templeos.holyc.xyz/Wb/Kernel/KMisc.html#l179">here</a> vs <a href="https://tinkeros.github.io/WbGit/Kernel/KMisc.html#l191">here</a>.
- Fixed more broken documentation links.
- Fixed Adam AutoComplete warnings on bootup.
- Clean up more $ characters from compiler exceptions in raw mode.
- Improved Seth Graphics Helper compatibility with older versions of QEMU (curse you Ubuntu for never updating QEMU, note that OSTestSuite/some of Terry's examples will still fail on some old versions of QEMU as they do in regular TempleOS)
- Fixed screen cache not being flushed after palette change.
- Disabled debug COM1 output so it can be used for other purposes
- Moved serial port code to Adam
- Fixed Aunt Nellie in OT1975

### Semi-complete list of changes between Terry's last TempleOS release and TinkerOS 5.06:
- Documentation similar to templeos.holyc.xyz, but functions are linkable and content which normally can only be accessed within TempleOS is now available on the web (see <a href="https://tinkeros.github.io/WbGit/Doc/HelpIndex.html#l93">here.</a>)
- VBE2 video mode support, provides 2x 4:3 (640x480 or 800x600) and 2x wide screen resolutions (<a href="https://youtu.be/E8UvMijEiUA">640x340</a> or 1280x512).  This can be configured using the auto installer or when building/configuring the kernel.
- Modified installer to make it easy to install with different resolutions and easy to optionally copy additional software to your installation.
- SSE support is enabled on the CPU (for now only used by some 3rd party apps)
- If you have more than 1 core a second core is used to help render providing a faster system (since normally everything by default happens on core 1).  This is particularly useful when running it on slow Intel Atom chips or under QEMU on other architectures.
- Added AfterEgypt and Chess so you don't have to dig into the supplemental discs to run them.
- Fixed Chess and Titanium (now called SpyHunt and changed a bit).
- Added an old school Oregon Trail text adventure.
- Minor improvements to Kernel to cause it to use less calls to MAlloc.
- Slipstreamed additional software in Extras folder so you can just use MountFile to mount extra discs and don't have to deal with changing virtual cd drives.
- You can dynamically change the frame rate SetFPS(60);
- Some people are annoyed by blinking and scrolling, functions ToggleBlink and ToggleScroll exist.
- You may access the up/down state of multiple keys without message parsing, see new <a href="https://tinkeros.github.io/WbGit/Demo/KeyState.html">KeyState Demo</a>
- When on the command line if you mis-type a command followed by a ; and hit enter, you may be able to re-paste your last command if it is still scrolling as text in the top of the window by using the F8 key.
- BMP file support has been restored.
- Raw mode text is also dumped out COM1 which helps when debugging the kernel without a display.
- Compiler now has an option to not warn about unused externs.
- When on the command line a Cd is frequently followed with a Dir so Cdd was born to do both.
- Modified Find to have optional parameter max_cnt which will limit number of results returned (otherwise for some patterns it can find so much it crashes the entire OS).
- Modified Profiler to output the function with the largest CPU percentage at the bottom of the output.
- Improvements to TaskRep output and FindTaskByTitle helps locate tasks by name.
- Mouse no longer dumps random characters into the debugger.
- Some exceptions have been tweaked so parts of the exceptions which previously were covered are now able to be seen.
- Pruned and refactored Adam so some things can be disabled in <a href="https://tinkeros.github.io/WbGit/MakeHome.html">MakeHome.HC</a> to improve performance on low power machines.
- Moved some of Adam to the Kernel so many useful file operations are avaiable before Adam is loaded.
- Removed Task Memory address from top bar to make room for more CPUs to be able to be displayed.
- Fixed Dir missing default arguments (which prevents default usage when KernelC.HH not in scope).
- Fixed IsDir hang if called with a path to an unmounted drive.
- MountIDEAuto now has ability to mount only ATAPI drives via optional parameter.
