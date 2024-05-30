package xfl.dom;

import xfl.edge.Edge;
import xfl.fill.FillStyle;
import openfl.geom.Matrix;
import openfl.geom.Point;
import xfl.stroke.StrokeStyle;
import haxe.xml.Access;

class DOMShape extends DOMShapeBase
{
	public var matrix:Matrix;
	public var transformationPoint:Point;
	public var edges:Array<Edge>;
	
	public function new()
	{
		super();
		edges = new Array<Edge>();
	}
	
	public static function parse(xml:Access):DOMShape
	{
		var shape = new DOMShape();
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "transformationPoint":
					shape.transformationPoint = xfl.geom.Point.parse(element.elements.next());
				case "matrix":
					shape.matrix = xfl.geom.Matrix.parse(element.elements.next());
				case "fills":
					for (childElement in element.elements)
					{
						shape.fills.push(FillStyle.parse(childElement));
					}
				case "strokes":
					for (childElement in element.elements)
					{
						shape.strokes.push(StrokeStyle.parse(childElement));
					}
				case "edges":
					for (childElement in element.elements)
					{
						var edge = Edge.parse(childElement);
						if (edge.edges != null && edge.edges != "")
						{
							shape.edges.push(edge);
						}
					}
			}
		}
		return shape;
	}
}
