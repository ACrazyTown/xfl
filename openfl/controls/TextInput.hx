package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.XFLSprite;
import openfl.display.XFLMovieClip;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Text input
 */
class TextInput extends UIComponent
{
	public var horizontalScrollPosition:Float;
	
	public var textField(get, never):TextField;
	public var htmlText(get, set):String;
	public var text(get, set):String;
	public var editable:Bool;
	
	private var _textField:TextField;
	private var _currentSkin:DisplayObject;
	
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.TextInput"));
		mouseChildren = false;
		buttonMode = true;
		setStyle("upSkin", getXFLElementUntyped("TextInput_upSkin"));
		setStyle("disabledSkin", getXFLElementUntyped("TextInput_disabledSkin"));
		_textField = new TextField();
		_textField.name = "textField";
		_textField.x = 0;
		_textField.y = 0;
		_textField.type = TextFieldType.INPUT;
		_textField.multiline = false;
		_textField.wordWrap = false;
		addChild(_textField);
		layoutChildren();
		draw();
	}
	
	override public function drawFocus(draw:Bool):Void {}
	
	public function get_textField():TextField
	{
		return _textField;
	}
	
	public function set_htmlText(_htmlText:String):String
	{
		_textField.htmlText = _htmlText;
		draw();
		return _textField.htmlText;
	}
	
	public function get_htmlText():String
	{
		return _textField.htmlText;
	}
	
	public function set_text(_text:String):String
	{
		_textField.text = _text;
		draw();
		return _textField.text;
	}
	
	public function get_text():String
	{
		return _textField.text;
	}
	
	override public function draw():Void
	{
		if (_currentSkin != null)
		{
			_currentSkin.visible = false;
			removeChild(_currentSkin);
		}
		var newSkin:DisplayObject = getStyle("upSkin");
		if (newSkin != null)
		{
			addChildAt(newSkin, 0);
			newSkin.visible = true;
			_currentSkin = newSkin;
		}
		var textFormat:TextFormat = getStyle("textFormat");
		if (textFormat != null && _textField.getTextFormat() != textFormat)
		{
			_textField.setTextFormat(textFormat);
			_textField.height = _textField.textHeight;
			_textField.y = (_height - _textField.height) / 2.0;
		}
	}
	
	override public function setSize(_width:Float, _height:Float)
	{
		super.setSize(_width, _height);
		layoutChildren();
	}
	
	private function layoutChildren()
	{
		cast(getStyle("upSkin"), XFLMovieClip).x = 0.0;
		cast(getStyle("upSkin"), XFLMovieClip).y = 0.0;
		cast(getStyle("upSkin"), XFLMovieClip).width = _width;
		cast(getStyle("upSkin"), XFLMovieClip).height = _height;
		
		cast(getStyle("disabledSkin"), XFLMovieClip).x = 0.0;
		cast(getStyle("disabledSkin"), XFLMovieClip).y = 0.0;
		cast(getStyle("disabledSkin"), XFLMovieClip).width = _width;
		cast(getStyle("disabledSkin"), XFLMovieClip).height = _height;
		
		_textField.width = _width;
		_textField.height = _height;
	}
}
