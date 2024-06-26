package openfl.controls;

import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;
import openfl.controls.LabelButton;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * CheckBox button
 */
class CheckBox extends LabelButton
{
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.CheckBox"));
		setStyle("upIcon", getXFLMovieClip("CheckBox_upIcon"));
		setStyle("overIcon", getXFLMovieClip("CheckBox_overIcon"));
		setStyle("downIcon", getXFLMovieClip("CheckBox_downIcon"));
		setStyle("disabledIcon", getXFLMovieClip("CheckBox_disabledIcon"));
		setStyle("selectedUpIcon", getXFLMovieClip("CheckBox_selectedUpIcon"));
		setStyle("selectedOverIcon", getXFLMovieClip("CheckBox_selectedOverIcon"));
		setStyle("selectedDownIcon", getXFLMovieClip("CheckBox_selectedDownIcon"));
		setStyle("selectedDisabledIcon", getXFLMovieClip("CheckBox_selectedDisabledIcon"));
		setMouseState("up");
		_selected = false;
		toggle = true;
	}
	
	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
	}
}
