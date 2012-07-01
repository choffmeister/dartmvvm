class NotConverter implements BindingConverter {
  Object convertFromModel(Object value) {
    bool boolValue = value is bool ? value : false;

    return !boolValue;
  }
  Object convertToModel(Object value) {
    bool boolValue = value is bool ? value : true;

    return !boolValue;
  }
}