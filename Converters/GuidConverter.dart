class GuidConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    return value != null && value is Guid ? value.toString() : '';
  }
  Object convertToModel(Object value) {
    try {
      return new Guid.parse(value.toString());
    } catch (var e) {
      throw new ValidationError('Must be a GUID');
    }
  }
}