class IntegerValidator implements BindingValidator {
  void validate(Object value) {
    RegExp regex = const RegExp(@"^[+|\-]?\d{1,8}$");
    String valueAsString = value != null ? value.toString() : '';

    if (!regex.hasMatch(valueAsString)) {
      throw new ValidationError('Must be a number');
    }
  }
}