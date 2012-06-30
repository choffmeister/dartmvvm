class NormalizedStringConverter implements BindingConverter {
  Object convertFromModel(Object value) => value != null ? value.toString() : '';
  Object convertToModel(Object value) {
    String trimmed = value.toString().trim();
    return trimmed != '' ? trimmed : null;
  }
}