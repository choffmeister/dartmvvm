class DoubleConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null && value is double ? value.toString() : '0';
  }
  Object convertToModel(Object value) {
    return Math.parseDouble(value.toString().trim());
  }
}