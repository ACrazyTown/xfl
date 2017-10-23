package openfl.containers;

import openfl.display.DisplayObject;
import openfl.display.XFLSprite;

/**
 * Textarea
 */
class ScrollPane extends XFLSprite {

    public var source: DisplayObject;

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
    }

    /**
     * Set size
     * @param width - Not yet
     * @param height - Not yet
     */
    public function setSize(width: Int, height: Int) : Void {
    }

    /**
     * Update
     */
    public function update() : Void {
    }

}
