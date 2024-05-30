package openfl.containers;

import openfl.core.UIComponent;
import openfl.controls.ScrollBar;
import openfl.controls.ScrollPolicy;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.events.ScrollEvent;
import openfl.events.MouseEvent;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;

/**
 * Base scroll pane
 */
class BaseScrollPane extends UIComponent
{
	public var source(get, set):DisplayObject;
	public var scrollY(get, set):Float;
	
	public var verticalScrollPosition(get, set):Float;
	public var verticalScrollBar(get, never):ScrollBar;
	
	public var horizontalScrollPolicy:String;
	public var verticalScrollPolicy:String;
	
	private var _scrollContainer:Sprite;
	private var _sourceContainer:Sprite;
	private var _source:DisplayObject;
	private var _scrollBar:ScrollBar;
	
	private var _dragMouseYLast:Null<Float>;
	private var _swipeVerticalDirection:Null<Float>;
	private var _swipeVerticalCurrent:Null<Float>;
	private var _swipeVerticalTime:Null<Float>;
	
	/**
	 * Public constructor
	**/
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments);
		horizontalScrollPolicy = ScrollPolicy.AUTO;
		verticalScrollPolicy = ScrollPolicy.AUTO;
		removeChild(getXFLDisplayObject("ScrollPane_upSkin"));
		removeChild(getXFLDisplayObject("ScrollPane_disabledSkin"));
		_scrollBar = getXFLScrollBar("ScrollBar");
		if (_scrollBar == null)
		{
			_scrollBar = new ScrollBar();
		}
		else
		{
			removeChild(_scrollBar);
		}
		_scrollBar.visible = false;
		_scrollBar.x = width - _scrollBar.width;
		_scrollBar.y = 0.0;
		_scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
		_sourceContainer = new Sprite();
		addChild(_sourceContainer);
		_scrollContainer = new Sprite();
		_sourceContainer.addChild(_scrollContainer);
		var maskSprite:Sprite = new Sprite();
		maskSprite.visible = false;
		_sourceContainer.addChild(maskSprite);
		_sourceContainer.mask = maskSprite;
		update();
		_sourceContainer.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		_sourceContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDragHandler);
	}
	
	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		_scrollBar.x = _width - _scrollBar.width;
		_scrollBar.y = 0.0;
		_scrollBar.setSize(_scrollBar.width, _height);
		update();
	}
	
	public function update():Void
	{
		disableSourceChildren();
		_scrollBar.x = _width - _scrollBar.width;
		_scrollBar.y = 0.0;
		_scrollBar.setSize(_scrollBar.width, _height);
		_scrollBar.maxScrollPosition = _source != null
			&& (_source.y + _source.height) > height ? (_source.y + _source.height) - height : 0.0;
		_scrollBar.lineScrollSize = 10.0;
		_scrollBar.pageScrollSize = height;
		_scrollBar.visible = verticalScrollPolicy == ScrollPolicy.ON
			|| (verticalScrollPolicy == ScrollPolicy.AUTO && _source != null && _source.y + _source.height > height);
		var maskSprite:Sprite = cast(_sourceContainer.mask, Sprite);
		maskSprite.graphics.clear();
		if (width > 0.0 && height > 0.0)
		{
			_sourceContainer.graphics.clear();
			_sourceContainer.graphics.beginFill(0xFF0000, 0.0);
			_sourceContainer.graphics.drawRect(0.0, 0.0, _width - (_scrollBar.visible == true ? _scrollBar.width : 0), _height);
			_sourceContainer.graphics.endFill();
			maskSprite.graphics.beginFill(0xFF0000);
			maskSprite.graphics.drawRect(0.0, 0.0, _width - (_scrollBar.visible == true ? _scrollBar.width : 0), _height);
			maskSprite.graphics.endFill();
		}
		if (_scrollBar.visible == true)
		{
			if (getChildByName(_scrollBar.name) == null)
				addChild(_scrollBar);
		}
		else
		{
			if (getChildByName(_scrollBar.name) != null)
				removeChild(_scrollBar);
		}
		scrollY = scrollY;
		updateSourceChildren();
	}
	
	private function get_source():DisplayObject
	{
		return _source;
	}
	
	private function set_source(_source:DisplayObject):DisplayObject
	{
		if (this._source != null)
			_scrollContainer.removeChild(this._source);
		this._source = _source;
		if (_source != null)
			_scrollContainer.addChild(this._source);
		update();
		return this._source;
	}
	
	private function get_scrollY():Float
	{
		return -_scrollContainer.y;
	}
	
	private function set_scrollY(scrollY:Float):Float
	{
		if (source == null)
			return scrollY;
		disableSourceChildren();
		if ((source.y + source.height) < height)
		{
			_scrollContainer.y = 0.0;
		}
		else
		{
			_scrollContainer.y = -scrollY;
		}
		if (_scrollContainer.y > 0.0)
		{
			_scrollContainer.y = 0.0;
		}
		else if (height > _source.y + source.height)
		{
			_scrollContainer.y = 0.0;
		}
		else if (_scrollContainer.y < -_source.y - source.height + height)
		{
			_scrollContainer.y = -_source.y - source.height + height;
		}
		_scrollBar.scrollPosition = scrollY;
		_scrollBar.validateNow();
		updateSourceChildren();
		return -_scrollContainer.y;
	}
	
	private function disableSourceChildren():Void
	{
		/*
			// TODO: a.drewke, not sure if this means any speed up
			if (_scrollBar.visible == true && getChildAt(numChildren - 1) != _scrollBar) {
				addChildAt(_scrollBar, numChildren - 1);
			}
			if (_source != null && Std.isOfType(_source, DisplayObjectContainer) == true) {
				var container: DisplayObjectContainer = cast(_source, DisplayObjectContainer);
				for (i in 0...container.numChildren - 1) {
					var child: DisplayObject = container.getChildAt(i);
					child.visible = false;
				}
			}
		 */
	}
	
	private function updateSourceChildren():Void
	{
		if (_scrollBar.visible == true && getChildAt(numChildren - 1) != _scrollBar)
		{
			addChildAt(_scrollBar, numChildren - 1);
		}
		if (_source != null && Std.isOfType(_source, DisplayObjectContainer) == true)
		{
			var container:DisplayObjectContainer = cast(_source, DisplayObjectContainer);
			for (i in 0...container.numChildren - 1)
			{
				var child:DisplayObject = container.getChildAt(i);
				child.visible = child.y + child.height > scrollY && child.y < scrollY + height;
			}
		}
	}
	
	private function get_verticalScrollBar():ScrollBar
	{
		return _scrollBar;
	}
	
	private function get_verticalScrollPosition():Float
	{
		return _scrollBar.scrollPosition;
	}
	
	private function set_verticalScrollPosition(scrollPosition:Float):Float
	{
		return _scrollBar.scrollPosition = scrollPosition;
	}
	
	private function onMouseWheel(event:MouseEvent):Void
	{
		if (_scrollBar.visible == false)
			return;
			
		if ((source.y + source.height) < height)
			return;
		scrollY = scrollY - event.delta;
		_scrollBar.scrollPosition = scrollY;
	}
	
	private function onScrollEvent(event:ScrollEvent):Void
	{
		scrollY = _scrollBar.scrollPosition;
	}
	
	private function doSwiping(event:Event):Void
	{
		if (parent == null)
		{
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, doSwiping);
			_swipeVerticalCurrent = null;
			_swipeVerticalDirection = null;
			_swipeVerticalTime = null;
			mouseChildren = true;
			return;
		}
		var now:Float = haxe.Timer.stamp();
		var scrollStep:Float = (now - _swipeVerticalTime) * _height / 45.0 * 60.0;
		_swipeVerticalCurrent += scrollStep;
		_swipeVerticalTime = now;
		scrollY += _swipeVerticalDirection * scrollStep;
		if (_swipeVerticalCurrent >= _height)
		{
			openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, doSwiping);
			_swipeVerticalCurrent = null;
			_swipeVerticalDirection = null;
			_swipeVerticalTime = null;
			mouseChildren = true;
		}
	}
	
	private function mouseDragHandler(e:MouseEvent):Void
	{
		if (_scrollBar.visible == false)
			return;
			
		if (parent == null)
		{
			_sourceContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDragHandler);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
			openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
		}
		
		switch (e.type)
		{
			case MouseEvent.MOUSE_MOVE:
				if (e.stageY > _dragMouseYLast + 25.0)
				{
					_swipeVerticalDirection = -1.0;
					_swipeVerticalCurrent = 0.0;
					_swipeVerticalTime = haxe.Timer.stamp();
					mouseChildren = false;
					openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, doSwiping);
					_dragMouseYLast = null;
					openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
					openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
				}
				else if (e.stageY < _dragMouseYLast - 25.0)
				{
					_swipeVerticalDirection = 1.0;
					_swipeVerticalCurrent = 0.0;
					_swipeVerticalTime = haxe.Timer.stamp();
					mouseChildren = false;
					openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, doSwiping);
					_dragMouseYLast = null;
					openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
					openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
				}
			case MouseEvent.MOUSE_DOWN:
				_dragMouseYLast = e.stageY;
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
				openfl.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
			case MouseEvent.MOUSE_UP:
				mouseChildren = true;
				_dragMouseYLast = null;
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
				openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
		}
	}
	
	override public function dispose():Void
	{
		_scrollBar.removeEventListener(ScrollEvent.SCROLL, onScrollEvent);
		_sourceContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDragHandler);
		openfl.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDragHandler);
		openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, doSwiping);
	}
}
