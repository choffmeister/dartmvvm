class ViewModel {
  Map _values;
  List<PropertyChangedListener> _listeners;

  ViewModel() : _values = new Map(), _listeners = new List<PropertyChangedListener>() {
  }

  static from(Object json) {
    if (json is ViewModel) {
      return json;
    } else if (json is Map) {
      ViewModel vm = new ViewModel();

      json.forEach((key, value) => vm[key] = ViewModel.from(value));

      return vm;
    } else if (json is List) {
      ListViewModel lvm = new ListViewModel();

      lvm.items.addAll(json.map((item) => ViewModel.from(item)));

      return lvm;
    } else {
      return json;
    }
  }

  void addListener(PropertyChangedListener listener) {
    _listeners.add(listener);
  }

  void removeListener(PropertyChangedListener listener) {
    int oldCount = _listeners.length;
    int index = _listeners.indexOf(listener);

    if (index >= 0) {
      _listeners.removeRange(index, 1);
    }
    // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
    assert(oldCount > _listeners.length);
  }

  void _notifyListeners(String propertyName, Object oldValue, Object newValue) {
    PropertyChangedEvent event = new PropertyChangedEvent(this, propertyName, oldValue, newValue);

    _listeners.forEach((PropertyChangedListener l) => l(event));
  }

  noSuchMethod(String functionName, List args) {
    if (args.length == 0 && functionName.startsWith("get:")) {
      var propertyName = functionName.replaceFirst("get:", "");

      return this[propertyName];
    }
    else if (args.length == 1 && functionName.startsWith("set:")) {
      var propertyName = functionName.replaceFirst("set:", "");

      this[propertyName] = args[0];
    }
  }

  operator [](String key) {
    if (_values.containsKey(key)) {
      return _values[key];
    } else {
      return null;
    }
  }

  operator []=(String key, Object value) {
    var currentValue = this[key];
    if (currentValue != value) {
      _values[key] = value;
      _notifyListeners(key, currentValue, value);
    }
  }

  bool containsKey(String key) => _values.containsKey(key);

  String toString() => _values.toString();
}