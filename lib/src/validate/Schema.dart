import './IValidationRule.dart';
import './ValidationResult.dart';
import './ValidationResultType.dart';
import './ValidationException.dart';
import '../reflect/ObjectReader.dart';
import '../reflect/TypeMatcher.dart';
import '../convert/TypeCode.dart';
import '../convert/TypeConverter.dart';

/**
 * Basic schema that validates values against a set of validation rules.
 * 
 * This schema is used as a basis for specific schemas to validate 
 * objects, project properties, arrays and maps.
 * 
 * See [ObjectSchema]
 * See [PropertySchema]
 * See [ArraySchema]
 * See [MapSchema]
 */
class Schema {
  bool _required;
  List<IValidationRule> _rules;

  /**
     * Creates a new instance of validation schema and sets its values.
     * 
     * - [required]  (optional) true to always require non-null values.
     * - [rules]     (optional) a list with validation rules.
     * 
     * See [IValidationRule]
     */
  Schema([bool req, List<IValidationRule> rules]) {
    this._required = req;
    this._required =  this._required != null? this._required:false;
    this._rules = rules;
  }

  /**
     * Gets a flag that always requires non-null values.
     * For null values it raises a validation error.
     * 
     * Returns true to always require non-null values and false to allow null values.
     */
  bool isRequired() {
    return this._required;
  }

  /**
     * Sets a flag that always requires non-null values.
     * 
     * - [value] true to always require non-null values and false to allow null values.
     */
  setRequired(bool value) {
    this._required = value;
  }

  /**
     * Gets validation rules to check values against.
     * 
     * Returns a list with validation rules.
     */
  List<IValidationRule> getRules() {
    return this._rules;
  }

  /**
     * Sets validation rules to check values against.
     * 
     * - [value] a list with validation rules.
     */
  setRules(List<IValidationRule> value) {
    this._rules = value;
  }

  /**
     * Makes validated values always required (non-null).
     * For null values the schema will raise errors.
     * 
     * This method returns reference to this exception to implement Builder pattern
     * to chain additional calls.
     * 
     * Returns this validation schema
     * 
     * See [makeOptional]
     */
  Schema makeRequired() {
    this._required = true;
    return this;
  }

  /**
     * Makes validated values optional.
     * Validation for null values will be skipped.
     * 
     * This method returns reference to this exception to implement Builder pattern
     * to chain additional calls.
     * 
     * Returns this validation schema
     * 
     * See [makeRequired]
     */
  Schema makeOptional() {
    this._required = false;
    return this;
  }

  /**
     * Adds validation rule to this schema.
     * 
     * This method returns reference to this exception to implement Builder pattern
     * to chain additional calls.
     * 
     * - [rule]  a validation rule to be added.
     * Returns this validation schema.
     */
  Schema withRule(IValidationRule rule) {
    if (this._rules == null) {
      this._rules = List<IValidationRule>();
    }
    this._rules.add(rule);
    return this;
  }

  /**
     * Validates a given value against the schema and configured validation rules.
     * 
     * - [path]      a dot notation path to the value.
     * - [value]     a value to be validated.
     * - [results]   a list with validation results to add new results.
     */
  void performValidation(
      String path, dynamic value, List<ValidationResult> results) {
    var name = path != null ? path : "value";

    if (value == null) {
      if (this.isRequired()) {
        results.add(new ValidationResult(path, ValidationResultType.Error,
            "VALUE_IS_NULL", name + " must not be null", "NOT NULL", null));
      }
    } else {
      value = ObjectReader.getValue(value);

      // Check validation rules
      if (this._rules != null) {
        for (var i = 0; i < this._rules.length; i++) {
          var rule = this._rules[i];
          rule.validate(path, this, value, results);
        }
      }
    }
  }

  String _typeToString(dynamic type) {
    if (type == null) return "unknown";
    if (type is num) return TypeConverter.asString(type as TypeCode);
    return type.toString();
  }

  /**
     * Validates a given value to match specified type.
     * The type can be defined as a Schema, type, a type name or [TypeCode]
     * When type is a Schema, it executes validation recursively against that Schema.
     * 
     * - [path]      a dot notation path to the value.
     * - [type]      a type to match the value type
     * - [value]     a value to be validated.
     * - [results]   a list with validation results to add new results.
     * 
     * See [performValidation]
     */
  void performTypeValidation(String path, dynamic type, dynamic value,
      List<ValidationResult> results) {
    // If type it not defined then skip
    if (type == null) return;

    // Perform validation against the schema
    if (type is Schema) {
      var schema = type as Schema;
      schema.performValidation(path, value, results);
      return;
    }

    // If value is null then skip
    value = ObjectReader.getValue(value);
    if (value == null) return;

    var name = path != null ? path : "value";
    var valueType = TypeConverter.toTypeCode(value);

    // Match types
    if (TypeMatcher.matchType(type, valueType, value)) return;

    results.add(new ValidationResult(
        path,
        ValidationResultType.Error,
        "TYPE_MISMATCH",
        name +
            " type must be " +
            this._typeToString(type) +
            " but found " +
            this._typeToString(valueType),
        type,
        valueType));
  }

  /**
     * Validates the given value and results validation results.
     * 
     * - [value]     a value to be validated.
     * Returns a list with validation results.
     * 
     * See [ValidationResult]
     */
  List<ValidationResult> validate(dynamic value) {
    var results = List<ValidationResult>();
    this.performValidation("", value, results);
    return results;
  }

  /**
     * Validates the given value and returns a [ValidationException] if errors were found.
     * 
     * - [correlationId]     (optional) transaction id to trace execution through call chain.
     * - [value]             a value to be validated.
     * - [strict]            true to treat warnings as errors.
     */
  ValidationException validateAndReturnException(
      String correlationId, dynamic value,
      [bool strict = false]) {
    List<ValidationResult> results = this.validate(value);
    return ValidationException.fromResults(correlationId, results, strict);
  }

  /**
     * Validates the given value and throws a [ValidationException] if errors were found.
     * 
     * - [correlationId]     (optional) transaction id to trace execution through call chain.
     * - [value]             a value to be validated.
     * - [strict]            true to treat warnings as errors.
     * 
     * See [ValidationException.throwExceptionIfNeeded]
     */
  void validateAndThrowException(String correlationId, dynamic value,
      [bool strict = false]) {
    List<ValidationResult> results = this.validate(value);
    ValidationException.throwExceptionIfNeeded(correlationId, results, strict);
  }
}
