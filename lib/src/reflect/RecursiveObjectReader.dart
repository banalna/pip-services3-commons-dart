import '../convert/TypeCode.dart';
import '../convert/TypeConverter.dart';
import './ObjectReader.dart';

/**
 * Helper class to perform property introspection and dynamic reading.
 * 
 * It is similar to [[ObjectReader]] but reads properties recursively
 * through the entire object graph. Nested property names are defined
 * using dot notation as "object.subobject.property"
 *
 * @see [[PropertyReflector]]
 * @see [[ObjectReader]]
 */
class RecursiveObjectReader {

  static bool _performHasProperty(obj, List<String> names, int nameIndex) {
		if (nameIndex < names.length - 1) {
			var value  = ObjectReader.getProperty(obj, names[nameIndex]);
			if (value != null)
				return RecursiveObjectReader._performHasProperty(value, names, nameIndex + 1);
			else
				return false;
		} else
			return ObjectReader.hasProperty(obj, names[nameIndex]);
	}

	/**
	 * Checks recursively if object or its subobjects has a property with specified name.
     * 
     * The object can be a user defined object, map or array.
     * The property name correspondently must be object property,
     * map key or array index.
	 * 
	 * @param obj 	an object to introspect.
	 * @param name 	a name of the property to check.
	 * @returns true if the object has the property and false if it doesn't.
	 */
	static bool hasProperty(obj, String name) {
    if (obj == null || name == null) return false;

    var names = name.split(".");
    if (names == null || names.length == 0) 
      return false;

    return RecursiveObjectReader._performHasProperty(obj, names, 0);
	}

  static _performGetProperty(obj, List<String> names, int nameIndex) {
		if (nameIndex < names.length - 1) {
			var value = ObjectReader.getProperty(obj, names[nameIndex]);
			if (value != null)
				return RecursiveObjectReader._performGetProperty(value, names, nameIndex + 1);
			else
				return null;
		} else
			return ObjectReader.getProperty(obj, names[nameIndex]);
	}

    /**
	 * Recursively gets value of object or its subobjects property specified by its name.
	 * 
     * The object can be a user defined object, map or array.
     * The property name correspondently must be object property,
     * map key or array index.
     * 
	 * @param obj 	an object to read property from.
	 * @param name 	a name of the property to get.
	 * @returns the property value or null if property doesn't exist or introspection failed.
     */
	static getProperty(obj, String name) {
    if (obj == null || name == null) return null;

    var names = name.split(".");
    if (names == null || names.length == 0) 
      return null;

    return RecursiveObjectReader._performGetProperty(obj, names, 0);
	}

	static bool _isSimpleValue(value) {
		var code = TypeConverter.toTypeCode(value);
		return code != TypeCode.Array && code != TypeCode.Map && code != TypeCode.Object;
	}
	
	static _performGetPropertyNames(obj, String path, List<String> result, List cycleDetect) {
		var map = ObjectReader.getProperties(obj);
		
    if (map.length > 0 && cycleDetect.length < 100) {		
			cycleDetect.add(obj);
			try {
				for (var key in map.keys) {
          var value = map[key];
					
					// Prevent cycles 
					if (cycleDetect.indexOf(value) >= 0)
						continue;

					var newPath = path != null ? path + "." + key : key;
					
					// Add simple values directly
					if (_isSimpleValue(value))
						result.add(newPath);
					// Recursively go to elements
					else
						_performGetPropertyNames(value, newPath, result, cycleDetect);				
				}
			} finally {
        var index = cycleDetect.indexOf(obj);
        if (index >= 0)
          cycleDetect.removeAt(index);
			}
		} else {
			if (path != null)
				result.add(path);
		}
	}

    /**
     * Recursively gets names of all properties implemented in specified object and its subobjects.
     * 
     * The object can be a user defined object, map or array.
     * Returned property name correspondently are object properties,
     * map keys or array indexes.
     * 
     * @param obj   an objec to introspect.
     * @returns a list with property names.
     */
	static List<String> getPropertyNames(obj) {
        var propertyNames = new List<String>();
		
        if (obj == null) {
        	return propertyNames;
        } else {
          var cycleDetect = [];
        	_performGetPropertyNames(obj, null, propertyNames, cycleDetect);
        	return propertyNames;
        }
	}

	static void _performGetProperties(obj, String path, result, List cycleDetect) {
		var map = ObjectReader.getProperties(obj);
		
    if (map.length > 0 && cycleDetect.length < 100) {		
			cycleDetect.add(obj);
			try {
				for (var key in map.keys) {
          var value = map[key];
					
					// Prevent cycles 
					if (cycleDetect.indexOf(value) >= 0)
						continue;

					var newPath = path != null ? path + "." + key : key;
					
					// Add simple values directly
					if (_isSimpleValue(value))
            result[newPath] = value;
					// Recursively go to elements
					else
						_performGetProperties(value, newPath, result, cycleDetect);				
				}
			} finally {
        var index = cycleDetect.indexOf(obj);
        if (index >= 0)
          cycleDetect.removeAt(index);
			}
		} else {
			if (path != null)
        result[path] = obj;
		}
	}

    /**
     * Get values of all properties in specified object and its subobjects
	 * and returns them as a map.
     * 
     * The object can be a user defined object, map or array.
     * Returned properties correspondently are object properties,
     * map key-pairs or array elements with their indexes.
     * 
     * @param obj   an object to get properties from.
     * @returns a map, containing the names of the object's properties and their values.
     */
	static Map<String, dynamic> getProperties(obj) {
    var properties = new Map<String, dynamic>();

    if (obj != null) {
      var cycleDetect = [];
      _performGetProperties(obj, null, properties, cycleDetect);
    }

    return properties;
	}
	
}
