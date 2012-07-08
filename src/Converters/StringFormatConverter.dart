class StringFormatConverter implements BindingConverter {
  BindingParameter _bindingParameter;

  StringFormatConverter(BindingParameter bindingParameter) : _bindingParameter = bindingParameter {
  }

  Object convertFromModel(Object value) {
    try {
      return _bindingParameter.options.replaceAll('\$', value.toString());
    } catch (var e) {
      throw new ValidationError('Error while applying string format');
    }
  }
  Object convertToModel(Object value) {
    throw new ValidationError('This converter does not support writing');
  }
}