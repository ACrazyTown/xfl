package openfl.controls;

import openfl.controls.TextInput;
import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.display.DisplayObject;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.geom.Point;
import openfl.text.TextField;
import xfl.Utils;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;

/**
 * Combo box grid
 */
class ComboBox extends UIComponent
{
	public var dataProvider(get, set):DataProvider;
	public var selectedIndex(get, set):Int;
	public var selectedItem(get, never):Dynamic;
	public var textField(get, never):TextInput;
	public var dropdown(get, never):List;
	
	private var _textField:TextInput;
	private var _list:List;
	private var _mouseState:String;
	private var _currentSkin:DisplayObject;
	private var _listOpened:Bool;
	
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.ComboBox"));
		mouseChildren = false;
		buttonMode = true;
		setStyle("upSkin", getXFLElementUntyped("ComboBox_upSkin"));
		setStyle("disabledSkin", getXFLElementUntyped("ComboBox_disabledSkin"));
		setStyle("downSkin", getXFLElementUntyped("ComboBox_downSkin"));
		setStyle("overSkin", getXFLElementUntyped("ComboBox_overSkin"));
		_list = cast getXFLElementUntyped("List");
		_list.addEventListener(Event.CHANGE, onListChange);
		_textField = cast getXFLElementUntyped("TextInput");
		_textField.visible = true;
		removeChild(_list);
		_currentSkin = null;
		_listOpened = false;
		addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
		layoutChildren();
		setMouseState("up");
	}
	
	private function get_dataProvider():DataProvider
	{
		return _list.dataProvider;
	}
	
	private function set_dataProvider(dataProvider:DataProvider):DataProvider
	{
		_list.dataProvider = dataProvider;
		selectedIndex = 0;
		_textField.text = dataProvider.length == 0 ? "" : dataProvider.getItemAt(selectedIndex).label;
		return dataProvider;
	}
	
	private function get_selectedIndex():Int
	{
		return _list.selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int
	{
		_list.selectedIndex = value;
		_textField.text = selectedIndex == -1 ? "" : dataProvider.getItemAt(selectedIndex).label;
		return _list.selectedIndex;
	}
	
	private function get_selectedItem():Dynamic
	{
		return _list.selectedItem;
	}
	
	private function get_textField():TextInput
	{
		return _textField;
	}
	
	private function get_dropdown():List
	{
		return _list;
	}
	
	override public function draw():Void
	{
		if (_currentSkin != null)
		{
			_currentSkin.visible = false;
			removeChild(_currentSkin);
		}
		var newSkin:DisplayObject = getStyle(_mouseState + "Skin");
		if (newSkin == null)
			newSkin = getStyle("upSkin");
		if (newSkin != null)
		{
			addChildAt(newSkin, 0);
			newSkin.visible = true;
			_currentSkin = newSkin;
		}
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
		
		cast(getStyle("downSkin"), XFLMovieClip).x = 0.0;
		cast(getStyle("downSkin"), XFLMovieClip).y = 0.0;
		cast(getStyle("downSkin"), XFLMovieClip).width = _width;
		cast(getStyle("downSkin"), XFLMovieClip).height = _height;
		
		cast(getStyle("overSkin"), XFLMovieClip).x = 0.0;
		cast(getStyle("overSkin"), XFLMovieClip).y = 0.0;
		cast(getStyle("overSkin"), XFLMovieClip).width = _width;
		cast(getStyle("overSkin"), XFLMovieClip).height = _height;
		
		_textField.x = 10.0;
		_textField.y = 0.0;
		_textField.width = _width - 30.0;
		_textField.height = _height;
	}
	
	public function setMouseState(newMouseState:String):Void
	{
		_mouseState = newMouseState == "out" ? "up" : newMouseState;
		draw();
	}
	
	private function onListChange(event:Event):Void
	{
		stage.removeChild(_list);
		_listOpened = false;
		_textField.text = dataProvider.getItemAt(selectedIndex).label;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseEvent);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function onStageMouseEvent(event:MouseEvent):Void
	{
		var target:DisplayObject = event.target;
		while (target != null)
		{
			if (target == this || target == _list)
				return;
			target = target.parent;
		}
		switch (event.type)
		{
			case MouseEvent.MOUSE_DOWN:
				setMouseState("up");
				if (_listOpened == true)
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseEvent);
					stage.removeChild(_list);
					_listOpened = false;
				}
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
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
				setMouseState("up");
			case MouseEvent.MOUSE_DOWN:
				setMouseState("down");
				if (_listOpened == false)
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseEvent);
					var stagePosition:Point = localToGlobal(new Point(0.0, _height));
					var stageSize:Point = localToGlobal(new Point(_width, 100.0));
					_list.x = stagePosition.x;
					_list.y = stagePosition.y;
					_list.visible = true;
					stage.addChild(_list);
					_list.setSize(stageSize.x - stagePosition.x, stageSize.y - stagePosition.y);
					_listOpened = true;
				}
				else
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseEvent);
					stage.removeChild(_list);
					_listOpened = false;
				}
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
	}
	
	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		layoutChildren();
	}
	
	override public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
		if (stage != null)
		{
			stage.removeChild(_list);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseEvent);
		}
		_list.dispose();
		_list.removeEventListener(Event.CHANGE, onListChange);
	}
}
