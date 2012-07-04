class NotEmptyConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    if (value is Collection) {
      return !value.isEmpty();
    } else {
      throw new ValidationError('Not empty converter is only supported on collections');
    }
  }
  Object convertToModel(Object value) {
    throw new ValidationError('This converter does not support writing');
  }
}