package xfl.fill;

import haxe.xml.Access;

class SolidColor
{
	public var alpha:Float;
	public var color:Int;
	
	public function new()
	{
		alpha = 1.0;
		color = 0x000000;
	}
	
	public static function parse(xml:Access):SolidColor
	{
		var solidColor = new SolidColor();
		if (xml.has.color)
			solidColor.color = Std.parseInt("0x" + xml.att.color.substr(1));
		if (xml.has.alpha)
			solidColor.alpha = Std.parseFloat(xml.att.alpha);
		return solidColor;
	}
}
