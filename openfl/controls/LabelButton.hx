package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import xfl.XFLSymbolArguments;
import xfl.dom.DOMTimeline;

class LabelButton extends UIComponent
{
	public var label(get, set):String;
	public var labelPlacement(get, set):String;
	public var textField(get, never):TextField;
	public var textPadding(get, set):Float;
	public var selected(get, set):Bool;
	public var toggle:Bool;
	
	private var _textPadding:Float;
	private var _labelPlacement:String;
	private var _textField:TextField;
	private var _selected:Bool;
	
	private var _mouseState:String;
	private var _currentIcon:DisplayObject;
	private var _currentSkin:DisplayObject;
	
	private var _maxIconWidth:Float;
	
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments);
		_textPadding = 5.0;
		_textField = new TextField();
		_textField.text = "label";
		_textField.x = _textPadding;
		_textField.y = 0;
		_textField.width = _textField.textWidth;
		_textField.height = _textField.textHeight;
		_textField.type = TextFieldType.DYNAMIC;
		_selected = false;
		toggle = false;
		mouseChildren = false;
		buttonMode = true;
		_currentIcon = null;
		_currentSkin = null;
		addChild(_textField);
		addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
		setMouseState("up");
	}
	
	override public function setStyle(style:String, value:Dynamic):Void
	{
		super.setStyle(style, value);
		var tmpIconWidth:Float = 0.0;
		_maxIconWidth = 0.0;
		_maxIconWidth = getStyle("upIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("upIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("overIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("overIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("downIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("downIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("disabledIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("disabledIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("selectedUpIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("selectedUpIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("selectedOverIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("selectedOverIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("selectedDownIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("selectedDownIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		_maxIconWidth = getStyle("selectedDisabledIcon") == null ? _maxIconWidth : (tmpIconWidth = cast(getStyle("selectedDisabledIcon"), DisplayObject)
			.width) > _maxIconWidth ? tmpIconWidth : _maxIconWidth;
		if (getStyle("upIcon") != null)
			cast(getStyle("upIcon"), DisplayObject).x = (_maxIconWidth - cast(getStyle("upIcon"), DisplayObject).width) / 2.0
				- getStyle("upIcon").getBounds(null).x;
		if (getStyle("overIcon") != null)
			cast(getStyle("overIcon"), DisplayObject).x = (_maxIconWidth - cast(getStyle("overIcon"), DisplayObject).width) / 2.0
				- getStyle("overIcon").getBounds(null).x;
		if (getStyle("downIcon") != null)
			cast(getStyle("downIcon"), DisplayObject).x = (_maxIconWidth - cast(getStyle("downIcon"), DisplayObject).width) / 2.0
				- getStyle("downIcon").getBounds(null).x;
		if (getStyle("disabledIcon") != null)
			cast(getStyle("disabledIcon"), DisplayObject).x = (_maxIconWidth
				- cast(getStyle("disabledIcon"), DisplayObject).width) / 2.0
				- getStyle("disabledIcon").getBounds(null).x;
		if (getStyle("selectedUpIcon") != null)
			cast(getStyle("selectedUpIcon"), DisplayObject).x = (_maxIconWidth
				- cast(getStyle("selectedUpIcon"), DisplayObject).width) / 2.0
				- getStyle("selectedUpIcon").getBounds(null).x;
		if (getStyle("selectedOverIcon") != null)
			cast(getStyle("selectedOverIcon"), DisplayObject).x = (_maxIconWidth
				- cast(getStyle("selectedOverIcon"), DisplayObject).width) / 2.0
				- getStyle("upIcon").getBounds(null).x;
		if (getStyle("selectedDownIcon") != null)
			cast(getStyle("selectedDownIcon"), DisplayObject).x = (_maxIconWidth
				- cast(getStyle("selectedDownIcon"), DisplayObject).width) / 2.0
				- getStyle("selectedDownIcon").getBounds(null).x;
		if (getStyle("selectedDisabledIcon") != null)
			cast(getStyle("selectedDisabledIcon"), DisplayObject).x = (_maxIconWidth
				- cast(getStyle("selectedDisabledIcon"), DisplayObject).width) / 2.0
				- getStyle("selectedDisabledIcon").getBounds(null).x;
	}
	
	private function get_textField():TextField
	{
		return _textField;
	}
	
	private function get_label():String
	{
		return _textField.text;
	}
	
	private function set_label(label:String):String
	{
		var defaultTextFormat:TextFormat = getStyle("defaultTextFormat");
		if (defaultTextFormat != null)
			_textField.defaultTextFormat = defaultTextFormat;
		_textField.text = label;
		_textField.height = _textField.textHeight;
		_textField.y = (_height - _textField.height) / 2.0;
		draw();
		return label;
	}
	
	private function get_labelPlacement():String
	{
		return _labelPlacement;
	}
	
	private function set_labelPlacement(labelPlacement:String):String
	{
		_labelPlacement = labelPlacement;
		draw();
		return _labelPlacement;
	}
	
	public function get_textPadding():Float
	{
		return _textPadding;
	}
	
	public function set_textPadding(_textPadding:Float):Float
	{
		_textField.x = _textPadding;
		_textField.width = _width - _textPadding;
		draw();
		return this._textPadding = _textPadding;
	}
	
	private function get_selected():Bool
	{
		return _selected;
	}
	
	private function set_selected(selected:Bool):Bool
	{
		_selected = selected;
		draw();
		return _selected;
	}
	
	public function setMouseState(newMouseState:String):Void
	{
		_mouseState = newMouseState == "out" ? "up" : newMouseState;
		draw();
	}
	
	override private function draw()
	{
		var textFormat = getStyle("textFormat");
		if (textFormat != null && _textField.getTextFormat() != textFormat)
		{
			_textField.setTextFormat(textFormat);
			_textField.height = _textField.textHeight;
			_textField.y = (_height - _textField.height) / 2.0;
		}
		if (_currentIcon != null)
			removeChild(_currentIcon);
		var styleName:String = (_selected == true ? "selected" + _mouseState.charAt(0).toUpperCase() + _mouseState.substr(1).toLowerCase() : _mouseState)
			+ "Icon";
		var newIcon:DisplayObject = getStyle(styleName);
		if (newIcon != null)
		{
			var iconBounds:Rectangle = newIcon.getBounds(null);
			newIcon.visible = true;
			newIcon.y = (_height - newIcon.height) / 2.0 - iconBounds.y;
			_textField.x = _maxIconWidth + _textPadding;
			_currentIcon = newIcon;
			addChild(_currentIcon);
		}
		if (_currentSkin != null)
		{
			_currentSkin.visible = false;
			removeChild(_currentSkin);
		}
		var newSkin:DisplayObject = getStyle((_selected == true ? "selected" + _mouseState.charAt(0)
			.toUpperCase() + _mouseState.substr(1).toLowerCase() : _mouseState)
			+ "Skin");
		if (newSkin == null)
			getStyle("upSkin");
		if (newSkin != null)
		{
			addChildAt(newSkin, 0);
			newSkin.x = 0.0;
			newSkin.y = 0.0;
			newSkin.width = _width;
			newSkin.height = _height;
			newSkin.visible = true;
			_currentSkin = newSkin;
		}
	}
	
	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		_textField.width = _width - _textPadding;
		_textField.y = (_height - _textField.height) / 2.0;
	}
	
	private function onMouseEvent(event:MouseEvent):Void
	{
		switch (event.type)
		{
			case MouseEvent.MOUSE_OVER:
				setMouseState("over");
			case MouseEvent.MOUSE_OUT:
				setMouseState("out");
			case MouseEvent.MOUSE_UP:
				if (toggle == true)
				{
					_selected = !_selected;
					dispatchEvent(new Event(Event.CHANGE));
				}
				setMouseState("up");
			case MouseEvent.MOUSE_DOWN:
				setMouseState("down");
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
	}
	
	override public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
	}
}
