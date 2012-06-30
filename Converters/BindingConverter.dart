interface BindingConverter default IdentityBindingConverter {
  BindingConverter();

  Object convertFromModel(Object value);
  Object convertToModel(Object value);
}

class IdentityBindingConverter implements BindingConverter {
  Object convertFromModel(Object value) => value;
  Object convertToModel(Object value) => value;
}