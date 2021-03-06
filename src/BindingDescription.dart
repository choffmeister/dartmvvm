class BindingDescription {
  bool _isValid;
  String _accessor;
  String _typeName;
  List<BindingParameter> _parameters;
  String _bindString;

  BindingBase _bindingInstance;
  List<BindingConverter> _converterInstances;
  List<BindingValidator> _validatorInstances;
  Element _element;
  Object _model;

  bool get isValid() => _isValid;
  String get accessor() => _accessor;
  String get typeName() => _typeName;
  List<BindingParameter> get parameters() => _parameters;

  BindingBase get bindingInstance() => _bindingInstance;
  set bindingInstance(BindingBase value) => _bindingInstance = value;
  List<BindingConverter> get converterInstances() => _converterInstances;
  List<BindingValidator> get validatorInstances() => _validatorInstances;
  Element get element() => _element;
  set element(Element value) => _element = value;
  Object get model() => _model;
  set model(Object value) => _model = value;

  BindingDescription.parse(String bindType, String bindString) : _isValid = false, _bindString = bindString {
    _typeName = bindType == 'data-bind' ? 'text' : bindType.substring(10);
    _parameters = new List<BindingParameter>();
    _converterInstances = new List<BindingConverter>();
    _validatorInstances = new List<BindingValidator>();

    if (bindString != null && bindString != '') {
      RegExp parseRegex = const RegExp(@"^{([^\s,]+)(\s*,\s*(.*))?}$");
      RegExp parseRegex2 = const RegExp(@"([^=]+)=([a-zA-Z]+)(\[[^\]]*\])?,?");

      Match match = parseRegex.firstMatch(bindString);

      if (match != null) {
        _accessor = match[1];

        if (match[3] != null) {
          for (Match match2 in parseRegex2.allMatches(match[3])) {
            String key = match2[1].toLowerCase();
            String value = match2[2].trim();

            BindingParameter bp = new BindingParameter();
            bp.key = match2[1].toLowerCase();
            bp.value = match2[2].trim();
            bp.options = match2[3] != null ? match2[3].substring(1, match2[3].length - 1) : null;
            _parameters.add(bp);
          }
        }

        _isValid = true;
      }
    }
  }

  String toString() => _bindString;
}

class BindingParameter {
  String key;
  String value;
  String options;
}