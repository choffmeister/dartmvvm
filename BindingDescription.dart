class BindingDescription {
  bool _isValid;
  List<String> _propertyNamePrecessors;
  String _propertyName;
  String _typeName;
  List<String> _converterNames;
  List<String> _validatorNames;
  BindingBase _bindingInstance;
  List<BindingConverter> _converterInstances;
  List<BindingValidator> _validatorInstances;
  Element _element;
  ViewModel _viewModel;

  bool get isValid() => _isValid;
  Collection get propertyNamePrecessors() => _propertyNamePrecessors;
  String get propertyName() => _propertyName;
  String get typeName() => _typeName;
  List<String> get converterNames() => _converterNames;
  List<String> get validatorNames() => _validatorNames;
  BindingBase get bindingInstance() => _bindingInstance;
  set bindingInstance(BindingBase value) => _bindingInstance = value;
  List<BindingConverter> get converterInstances() => _converterInstances;
  List<BindingValidator> get validatorInstances() => _validatorInstances;
  Element get element() => _element;
  set element(Element value) => _element = value;
  ViewModel get viewModel() => _viewModel;
  set viewModel(ViewModel value) => _viewModel = value;

  BindingDescription.parse(String str) : _isValid = false {
    _converterNames = new List<String>();
    _validatorNames = new List<String>();
    _converterInstances = new List<BindingConverter>();
    _validatorInstances = new List<BindingValidator>();

    if (str != null && str != '') {
      RegExp parseRegex = const RegExp(@"^{([a-zA-Z0-9\.]+)(\s*,\s*(.*))?}$");
      RegExp parseRegex2 = const RegExp(@"([^=]+)=([^,]+),?");

      Match match = parseRegex.firstMatch(str);

      if (match != null) {
        _propertyName = match[1];

        if (match[3] != null) {
          for (Match match2 in parseRegex2.allMatches(match[3])) {
            String key = match2[1].toLowerCase();
            String value = match2[2].trim();

            switch (key) {
              case 'type':
                _typeName = value.toLowerCase();
                break;
              case 'conv':
                _converterNames.add(value.toLowerCase());
                break;
              case 'vali':
                _validatorNames.add(value.toLowerCase());
            }
          }
        }

        _propertyNamePrecessors = propertyName.split('.');
        _propertyName = _propertyNamePrecessors.removeLast();

        _isValid = true;
      }
    }
  }
}