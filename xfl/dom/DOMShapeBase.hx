package xfl.dom;

import xfl.fill.FillStyle;
import xfl.stroke.StrokeStyle;

class DOMShapeBase
{
	public var fills:Array<FillStyle>;
	public var strokes:Array<StrokeStyle>;
	
	private function new()
	{
		fills = new Array<FillStyle>();
		strokes = new Array<StrokeStyle>();
	}
}
