package openfl.containers;

import com.slipshift.engine.helpers.Utils;

import openfl.core.UIComponent;
import openfl.controls.ScrollBar;
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
class BaseScrollPane extends UIComponent {

    public var source(get, set): DisplayObject;
    public var scrollY(get, set): Float;

    public var verticalScrollPosition(get, set): Float;
    public var verticalScrollBar(get, never): ScrollBar;

    public var horizontalScrollPolicy: String;
    public var verticalScrollPolicy: String;

    private var scrollContainer: Sprite;
    private var _source: DisplayObject;
    private var _scrollBar: ScrollBar;

    /**
     * Public constructor
     **/
    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments);
        _scrollBar = getXFLScrollBar("ScrollBar");
        if (_scrollBar == null) {
            _scrollBar = new ScrollBar();
        } else {
            removeChild(_scrollBar);
        }
        _scrollBar.visible = false;
        _scrollBar.x = width - _scrollBar.width;
        _scrollBar.y = 0.0;
        _scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
        var maskSprite: Sprite = new Sprite();
        maskSprite.visible = false;
        addChild(maskSprite);
        scrollContainer = new Sprite();
        addChild(scrollContainer);
        mask = maskSprite;
        update();
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    override public function setSize(_width: Float, _height: Float) : Void {
        super.setSize(_width, _height);
        _scrollBar.x = _width - _scrollBar.width;
        _scrollBar.y = 0.0;
        _scrollBar.setSize(_scrollBar.width, _height);
        update();
    }

    public function update() : Void {
        disableSourceChildren();
        var maskSprite: Sprite = cast(mask, Sprite);
        maskSprite.graphics.clear();
        if (width > 0.0 && height > 0.0) {
            maskSprite.graphics.beginFill(0x000000);
            maskSprite.graphics.drawRect(0.0, 0.0, _width, _height);
            maskSprite.graphics.endFill();
        }
        _scrollBar.x = _width - _scrollBar.width;
        _scrollBar.y = 0.0;
        _scrollBar.setSize(_scrollBar.width, _height);
        _scrollBar.maxScrollPosition = _source != null && (_source.y + _source.height) > height?(_source.y + _source.height) - height:0.0;
        _scrollBar.lineScrollSize = 10.0;
        _scrollBar.pageScrollSize = height;
        _scrollBar.visible = _source != null && (_source.y + _source.height) > height;
        if (_scrollBar.visible == true) {
            addChild(_scrollBar);
        } else {
            removeChild(_scrollBar);
        }
        updateSourceChildren();
    }

    private function get_source(): DisplayObject {
        return _source;
    }

    private function set_source(_source: DisplayObject): DisplayObject {
        if (this._source != null) scrollContainer.removeChild(this._source);
        this._source = _source;
        scrollContainer.addChild(this._source);
        update();
        return this._source;
    }

    private function get_scrollY(): Float {
        return -scrollContainer.y;
    }

    private function set_scrollY(scrollY: Float): Float {
        disableSourceChildren();
        if ((source.y + source.height) < height) return scrollContainer.y = 0.0;
        scrollContainer.y = -scrollY;
        if (scrollContainer.y > 0.0) scrollContainer.y = 0.0;
        if (scrollContainer.y < -_source.y - source.height + height) scrollContainer.y = -_source.y - source.height + height;
        _scrollBar.validateNow();
        updateSourceChildren();
        return -scrollContainer.y;
    }

    private function disableSourceChildren(): Void {
        /*
        // TODO: a.drewke, not sure if this means any speed up
        if (_scrollBar.visible == true && getChildAt(numChildren - 1) != _scrollBar) {
            addChildAt(_scrollBar, numChildren - 1);
        }
        if (_source != null && Std.is(_source, DisplayObjectContainer) == true) {
            var container: DisplayObjectContainer = cast(_source, DisplayObjectContainer);
            for (i in 0...container.numChildren - 1) {
                var child: DisplayObject = container.getChildAt(i);
                child.visible = false;
            }
        }
        */
    }

    private function updateSourceChildren(): Void {
        if (_scrollBar.visible == true && getChildAt(numChildren - 1) != _scrollBar) {
            addChildAt(_scrollBar, numChildren - 1);
        }
        if (_source != null && Std.is(_source, DisplayObjectContainer) == true) {
            var container: DisplayObjectContainer = cast(_source, DisplayObjectContainer);
            for (i in 0...container.numChildren - 1) {
                var child: DisplayObject = container.getChildAt(i);
                child.visible = 
                    child.y + child.height > scrollY &&
                    child.y < scrollY + height;
            }
        }
    }

    private function get_verticalScrollBar(): ScrollBar {
        return _scrollBar;
    }

    private function get_verticalScrollPosition(): Float {
        return _scrollBar.scrollPosition;
    }

    private function set_verticalScrollPosition(scrollPosition: Float): Float {
        return _scrollBar.scrollPosition = scrollPosition;
    }

    private function onMouseWheel(event: MouseEvent): Void {
        if ((source.y + source.height) < height) return;
        scrollY = scrollY - event.delta;
        _scrollBar.scrollPosition = scrollY;
    }

    private function onScrollEvent(event: ScrollEvent): Void {
        scrollY = _scrollBar.scrollPosition;
    }

}