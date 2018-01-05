package openfl.containers;

import openfl.core.UIComponent;
import openfl.controls.ScrollBar;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.events.ScrollEvent;
import openfl.events.MouseEvent;
import xfl.XFL;
import xfl.XFLAssets;

/**
 * Base scroll pane
 */
class BaseScrollPane extends UIComponent {

    public var source(get, set): DisplayObject;
    public var scrollY(get, set): Float;

    public var horizontalScrollPolicy: String;
    public var verticalScrollPolicy: String;

    public var verticalScrollPosition: Int;
    public var verticalScrollBar: Dynamic;

    private var _source: DisplayObject;
    private var scrollBar: ScrollBar;

    /**
     * Public constructor
     **/
    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments);
        scrollBar = getXFLScrollBar("ScrollBar");
        if (scrollBar != null) {
            scrollBar.visible = true;
            scrollBar.x = 0.0;
            scrollBar.y = 0.0;
            scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
        }
        var maskSprite: Sprite = new Sprite();
        maskSprite.visible = false;
        addChild(maskSprite);
        mask = maskSprite;
        update();
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    override public function setSize(_width: Float, _height: Float) : Void {
        super.setSize(_width, _height);
        if (scrollBar != null) scrollBar.setSize(width, height);
        update();
    }

    public function update() : Void {
        var maskSprite: Sprite = cast(mask, Sprite);
        maskSprite.graphics.clear();
        if (width > 0.0 && height > 0.0) {
            maskSprite.graphics.beginFill(0x000000);
            maskSprite.graphics.drawRect(0.0, 0.0, _width, _height);
            maskSprite.graphics.endFill();
        }
        if (scrollBar != null) {
            if (getChildAt(numChildren - 1) != scrollBar) {
                trace("abcabc");
                addChildAt(scrollBar, numChildren - 1);
            }
            scrollBar.maxScrollPosition = _source != null && _source.height > height?_source.height - height:0.0;
            scrollBar.lineScrollSize = 10.0;
            scrollBar.pageScrollSize = height;
            scrollBar.visible = _source != null && _source.height > height;
        }
    }

    private function get_source(): DisplayObject {
        return _source;
    }

    private function set_source(_source: DisplayObject): DisplayObject {
        if (this._source != null) removeChild(this._source);
        this._source = _source;
        addChild(this._source);
        update();
        return this._source;
    }

    private function get_scrollY(): Float {
        return -source.y;
    }

    private function set_scrollY(scrollY: Float): Float {
        if (source.height < height) return source.y = 0.0;
        source.y = -scrollY;
        if (source.y > 0.0) source.y = 0.0;
        if (source.y < -(source.height - height)) source.y = -(source.height - height);
        if (scrollBar != null) scrollBar.validateNow();
        return source.y;
    }

    private function onMouseWheel(event: MouseEvent): Void {
        if (source.height < height) return;
        scrollY = scrollY - event.delta;
        if (scrollBar != null) scrollBar.scrollPosition = scrollY;
    }

    private function onScrollEvent(event: ScrollEvent): Void {
        if (scrollBar != null) scrollY = scrollBar.scrollPosition;
    }

}
