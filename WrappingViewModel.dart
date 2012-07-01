class WrappingViewModel extends ViewModelImpl {
  Map _extraValues;
  List<PropertyChangedListener> _extraListeners;
  ViewModel _inner;
  List<String> _extraValueNames;

  WrappingViewModel(ViewModel inner, List<String> extraValueNames)
      : _extraValues = new Map(), _extraListeners = new List<PropertyChangedListener>(),
        _inner = inner, _extraValueNames = extraValueNames {
    _inner.addListener(_innerViewModelChanged);
  }

  void _innerViewModelChanged(PropertyChangedEvent event) {
    _notifyListeners(event.propertyName, event.oldValue, event.newValue);
  }

  void addListener(PropertyChangedListener listener) {
    _extraListeners.add(listener);
  }

  void removeListener(PropertyChangedListener listener) {
    int index = _extraListeners.indexOf(listener);

    if (index >= 0) {
      _extraListeners.removeRange(index, 1);
    }
  }

  void _notifyListeners(String propertyName, Object oldValue, Object newValue) {
    PropertyChangedEvent event = new PropertyChangedEvent(this, propertyName, oldValue, newValue);

    _extraListeners.forEach((PropertyChangedListener l) => l(event));
  }

  operator [](String key) {
    if (_extraValueNames.indexOf(key) != -1 && _extraValues.containsKey(key)) {
      return _extraValues[key];
    } else if (_inner.containsKey(key)) {
      return _inner[key];
    } else {
      return null;
    }
  }

  operator []=(String key, Object value) {
    var currentValue = this[key];
    if (currentValue != value) {
      if (_extraValueNames.indexOf(key) != -1) {
        _extraValues[key] = value;
        _notifyListeners(key, currentValue, value);
      } else {
        _inner[key] = value;
      }
    }
  }

  bool containsKey(String key) => _extraValues.containsKey(key) || _inner.containsKey(key);
}