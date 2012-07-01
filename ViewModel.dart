class ViewModel {
  Map _values;
  List<PropertyChangedListener> _listeners;

  ViewModel() : _values = new Map(), _listeners = new List<PropertyChangedListener>() {
  }

  void addListener(PropertyChangedListener listener) {
    _listeners.add(listener);
  }

  void removeListener(PropertyChangedListener listener) {
    int index = _listeners.indexOf(listener);

    if (index >= 0) {
      _listeners.removeRange(index, 1);
    }
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
}