package xfl.dom;

import xfl.geom.Matrix;
import xfl.geom.Point;
import haxe.xml.Fast;

class DOMComponentInstance {

    public var name: String;
	public var libraryItemName: String;
	public var matrix: Matrix;
	public var transformationPoint: Point;
	public var variables: Map<String, DOMComponentInstanceVariable>;

	public function new () {
		variables = new Map<String, DOMComponentInstanceVariable>();
	}

	public static function parse(xml: Fast): DOMComponentInstance {
		var componentInstance: DOMComponentInstance = new DOMComponentInstance();
        componentInstance.name = xml.has.name == true?xml.att.name:null;
		componentInstance.libraryItemName = xml.att.libraryItemName;
		for (element in xml.elements) {
			switch (element.name) {
				case "transformationPoint":
					componentInstance.transformationPoint = Point.parse(element.elements.next());
				case "matrix":
					componentInstance.matrix = Matrix.parse(element.elements.next());
				case "parametersAsXML":
					var propertyElementXML: Fast = new Fast(Xml.parse(element.innerData));
					for (propertyElement in propertyElementXML.elements) {
						if (propertyElement.name == "property") {
							var inspectableElement = propertyElement.node.Inspectable;
							var componentInstanceVariable: DOMComponentInstanceVariable = DOMComponentInstanceVariable.parse(inspectableElement);
							componentInstance.variables.set(componentInstanceVariable.variable, componentInstanceVariable);
						}
					}
			}
		}
		return componentInstance;
	}

}
