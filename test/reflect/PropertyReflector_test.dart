import 'package:test/test.dart';

import './TestClass.dart';
import '../../lib/src/reflect/PropertyReflector.dart';

void main() {
  group('PropertyReflector', () {
    test('Get Property', () {
      var obj =  TestClass();

      var value = PropertyReflector.getProperty(obj, 'privateField');
      expect(value, isNull);

      value = PropertyReflector.getProperty(obj, 'publicField');
      expect(value, equals('ABC'));

      value = PropertyReflector.getProperty(obj, 'PublicProp');
      expect(value, isNotNull);
    });

    test('Get Properties', () {
      var obj =  TestClass();
      var names = PropertyReflector.getPropertyNames(obj);
      expect(names.length, equals(2));
      expect(names.indexOf('publicField') >= 0, isTrue);
      expect(names.indexOf('publicProp') >= 0, isTrue);

      var map = PropertyReflector.getProperties(obj);
      expect(map.length, equals(2));
      expect(map['publicField'], equals('ABC'));
      expect(map['publicProp'], isNotNull);
    });

    test('Set Property', () {
      var obj =  TestClass();

      PropertyReflector.setProperty(obj, 'publicField', 'XYZ');
      var value1 = PropertyReflector.getProperty(obj, 'publicField');
      expect(value1, equals('XYZ'));

      var value =  DateTime(1975, 4, 8);
      PropertyReflector.setProperty(obj, 'PublicProp', value);
      var value2 = PropertyReflector.getProperty(obj, 'PublicProp');
      expect(value2, equals(value));
    });

    test('Set Properties', () {
      var obj =  TestClass();

      var value =  DateTime(1975, 4, 8);
      var map =  Map<String, dynamic>();
      map['publicField'] = 'XYZ';
      map['PublicProp'] = value;
      PropertyReflector.setProperties(obj, map);

      var value1 = PropertyReflector.getProperty(obj, 'publicField');
      expect(value1, equals('XYZ'));

      var value2 = PropertyReflector.getProperty(obj, 'PublicProp');
      expect(value2, equals(value));
    });
  });
}
