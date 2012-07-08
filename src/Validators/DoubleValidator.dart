class DoubleValidator implements BindingValidator {
  void validate(Object value) {
    String valueAsString = value != null ? value.toString() : '';

    try {
      double res = Math.parseDouble(valueAsString);
    } catch (var e) {
      throw new ValidationError('Must be a floating point number');
    }
  }
}