class ViewModel extends HashMapImplementation<String, Object> {
  final List<PropertyChangedListener> _listeners;

  ViewModel() : _listeners = new List<PropertyChangedListener>();

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

  void onModelChanged(PropertyChangedEvent event) {
  }

  void _notifyListeners(String propertyName) {
    PropertyChangedEvent event = new PropertyChangedEvent(this, propertyName);

    onModelChanged(event);
    _listeners.forEach((PropertyChangedListener l) => l(event));
  }

  Object operator [](String key) {
    if (super.containsKey(key)) {
      return super[key];
    } else {
      throw new Exception('View model has no property $key');
    }
  }

  void operator []=(String key, Object value) {
    if (!super.containsKey(key) || super[key] != value) {
      super[key] = value;
      _notifyListeners(key);
    }
  }
}