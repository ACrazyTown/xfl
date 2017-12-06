package xfl.geom;

import haxe.xml.Fast;

class Matrix extends openfl.geom.Matrix {
	
	public static function parse(xml:Fast): Matrix {
		var matrix = new Matrix();
		if (xml.has.a) matrix.a = Std.parseFloat (xml.att.a);
		if (xml.has.b) matrix.b = Std.parseFloat (xml.att.b);
		if (xml.has.c) matrix.c = Std.parseFloat (xml.att.c);
		if (xml.has.d) matrix.d = Std.parseFloat (xml.att.d);
		if (xml.has.tx) matrix.tx = Std.parseFloat (xml.att.tx);
		if (xml.has.ty) matrix.ty = Std.parseFloat (xml.att.ty);
		return matrix;
	}

}