class IntegerConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null && value is int ? value.toString() : '0';
  }
  Object convertToModel(Object value) {
    try {
      return Math.parseInt(value.toString().trim());
    } catch (var e) {
      throw new ValidationError('Must be a number');
    }
  }
}