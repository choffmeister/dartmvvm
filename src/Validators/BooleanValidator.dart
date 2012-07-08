class BooleanValidator implements BindingValidator {
  void validate(Object value) {
    if (!(value is bool)) {
      throw new ValidationError('Must be a boolean');
    }
  }
}