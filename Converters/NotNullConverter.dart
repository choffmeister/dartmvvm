class NotNullConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null ? true : false;
  }
  Object convertToModel(Object value) {
    throw new ValidationError('This converter does not support writing');
  }
}