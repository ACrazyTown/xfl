package xfl.fill;

import haxe.xml.Access;
import openfl.geom.Matrix;

class Bitmap
{
	public var bitmapPath:String;
	public var matrix:Matrix;
	
	public function new() {}
	
	public static function parse(xml:Access):Bitmap
	{
		var bitmap:Bitmap = new Bitmap();
		bitmap.bitmapPath = xml.att.bitmapPath;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "matrix":
					bitmap.matrix = xfl.geom.Matrix.parse(element.elements.next());
			}
		}
		return bitmap;
	}
}
