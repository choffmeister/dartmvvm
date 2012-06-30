class BooleanConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null && value is bool ? value.toString() : 'false';
  }
  Object convertToModel(Object value) {
    if (value is int) {
      return value != 0;
    } else if (value is String && (value == 'true' || value == 'false')) {
      return value == 'true';
    } else if (value is String && (value == 'on' || value == 'off')) {
      return value == 'on';
    } else if (value is String && (value == '1' || value == '0')) {
      return value == '1';
    } else {
      throw new ValidationError('Must be a boolean');
    }
  }
}