class ViewModelBindingDescription {
  bool _isValid;
  String _propertyName;
  String _type;

  bool get isValid() => _isValid;
  String get propertyName() => _propertyName;
  String get type() => _type;

  ViewModelBindingDescription.parse(String str) : _isValid = false {
    if (str != null && str != '') {
      RegExp parseRegex = const RegExp(@"^{([a-zA-Z0-9]+)(\s*,\s*(.*))?}$");
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
                _type = value.toLowerCase();
                break;
            }
          }
        }
        _isValid = true;
      }
    }
  }
}