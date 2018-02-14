1. XFL

1.1 What is it?

	XFL is a leightweight implementation of Adobe Flash XFL and related things and GSAP library tweens for Haxe/OpenFL.

1.2 Why?

	I am developing XFL while beeing hired to port a medium sized browser game frontend from Adobe Flash to OpenFL/Haxe. See "https://www.pirate-century.com". 

1.3 Who did this?

	XFL is beeing programmed by Andreas Drewke at Pixel Racoons GmbH. Pixel Racoons allows me to open source this! Thank you.
	XFL basic functionality like parsing was derived from "https://github.com/haxenme-old/xfl".

1.4 What is already working without claiming to be 100% complete

  - XFL parsing
  - XFL asset management, like retrieving bitmaps, sounds, ... from XFL
  - XFL sprite, XFL movieclip, XFL based shapes, UI components, ... creation from XFL/XML files
  - XFL tween functionality which derived most of its API from Greensock tween library
  - UI element related classes using XFL skinning
    - openfl.core.UIElement
    - openfl.containers.BaseScrollPane,openfl.containers.ScrollPane
    - openfl.controls.CheckBox
    - openfl.controls.DataGrid
    - openfl.controls.LabelButton
    - openfl.controls.RadioButton
    - openfl.controls.ScrollBar, openfl.controls.UIScrollBar
    - openfl.controls.Slider
    - openfl.controls.TextArea

1.5 Notes

    This is not finished yet! And the code still looks ugly as I did all the things with time in mind. I will maybe clean it up later and document on things and such.

