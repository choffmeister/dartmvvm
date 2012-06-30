class DoubleConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null && value is double ? value.toString() : '0';
  }

  Object convertToModel(Object value) {
    try {
      return Math.parseDouble(value.toString().trim());
    } catch (var e) {
      throw new ValidationError('Must be a floating point number');
    }
  }
}