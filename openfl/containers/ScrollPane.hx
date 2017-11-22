package openfl.containers;

import com.slipshift.engine.helpers.Utils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;

/**
 * Textarea
 */
class ScrollPane extends Sprite {

    private var _width: Float;
    private var _height: Float;
    private var _source: DisplayObject;

    public var source(get, set): DisplayObject;

    public var horizontalScrollPolicy: String;
    public var verticalScrollPolicy: String;

    public var verticalScrollPosition: Int;

    public var verticalScrollBar: Dynamic;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
        _width = 0.0;
        _height = 0.0;
        var maskSprite: Sprite = new Sprite();
        maskSprite.visible = false;
        addChild(maskSprite);
        mask = maskSprite;
        update();
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    /**
     * Set size
     * @param width - Not yet
     * @param height - Not yet
     */
    public function setSize(width: Int, height: Int) : Void {
        _width = width;
        _height = height;
        update();
    }

    /**
     * Update
     */
    public function update() : Void {
        var maskSprite: Sprite = cast(mask, Sprite);
        maskSprite.graphics.clear();
        maskSprite.graphics.beginFill(0x000000);
        maskSprite.graphics.drawRect(0.0, 0.0, _width, _height);
        maskSprite.graphics.endFill();
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

    override private function get_width(): Float {
        return _width;
    }

    override private function set_width(width: Float): Float {
        _width = width;
        update();
        return _width;
    }

    override private function get_height(): Float {
        return _height;
    }

    override private function set_height(height: Float): Float {
        _height = height;
        update();
        return _height;
    }

    private function onMouseWheel(event: MouseEvent): Void {
        source.y+= event.delta;
        if (source.y > 0.0) source.y = 0.0;
        if (source.y < -(source.height - _height)) source.y = -(source.height - _height);
    }

}
