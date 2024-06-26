package xfl.dom;

import openfl.geom.Matrix;
import openfl.geom.Point;
import haxe.xml.Access;

class DOMBitmapInstance
{
	public var libraryItemName:String;
	public var matrix:Matrix;
	public var transformationPoint:Point;
	
	public function new() {}
	
	public static function parse(xml:Access):DOMBitmapInstance
	{
		var bitmapInstance:DOMBitmapInstance = new DOMBitmapInstance();
		bitmapInstance.libraryItemName = xml.att.libraryItemName;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					bitmapInstance.transformationPoint = xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					bitmapInstance.matrix = xfl.geom.Matrix.parse(element.elements.next());
			}
		}
		return bitmapInstance;
	}
}
