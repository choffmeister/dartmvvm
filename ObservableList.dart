class ObservableList<E> implements List {
  List<E> _inner;
  List<ObservableListChangedListener> _listeners;

  ObservableList([int length]) : this.from(new List(length)) {
  }

  ObservableList.from(Iterable<E> other) {
    _listeners = new List<ObservableListChangedListener>();
    _inner = new List.from(other);
  }

  void addHandler(ObservableListChangedListener listener) {
    _listeners.add(listener);
  }

  void removeHandler(ObservableListChangedListener listener) {
    int index = _listeners.indexOf(listener);

    if (index >= 0) {
      _listeners.removeRange(index, 1);
    }
  }

  void _notifyListeners() {
    //TODO: add more details to event, so the listener must not rescan the list
    ObservableListChangedEvent event = new ObservableListChangedEvent(this);

    _listeners.forEach((ObservableListChangedListener l) => l(event));
  }

  void operator []=(int index, E value) {
    _inner[index] = value;
    _notifyListeners();
  }

  void set length(int newLength) {
    _inner.length = newLength;
    _notifyListeners();
  }

  void add(E value) {
    _inner.add(value);
    _notifyListeners();
  }

  void addLast(E value) {
    _inner.add(value);
    _notifyListeners();
  }
  void addAll(Collection<E> collection) {
    _inner.addAll(collection);
    _notifyListeners();
  }

  void sort(int compare(E a, E b)) {
    _inner.sort(compare);
    _notifyListeners();
  }

  void clear() {
    _inner.clear();
    _notifyListeners();
  }

  E removeLast() {
    E item = _inner.removeLast();
    _notifyListeners();
    return item;
  }

  void setRange(int start, int length, List<E> from, [int startFrom]) {
    _inner.setRange(start, length, from, startFrom);
    _notifyListeners();
  }

  void removeRange(int start, int length) {
    _inner.removeRange(start, length);
    _notifyListeners();
  }

  void insertRange(int start, int length, [E initialValue]) {
    _inner.insertRange(start, length, initialValue);
    _notifyListeners();
  }

  Iterator<E> iterator() => _inner.iterator();
  void forEach(void f(E element)) => _inner.forEach(f);
  Collection map(f(E element)) => _inner.map(f);
  Collection<E> filter(bool f(E element)) => _inner.filter(f);
  bool every(bool f(E element)) => _inner.every(f);
  bool some(bool f(E element)) => _inner.some(f);
  bool isEmpty() => _inner.isEmpty();
  int get length() => _inner.length;
  E operator [](int index) => _inner[index];
  int indexOf(E element, [int start]) => _inner.indexOf(element, start);
  int lastIndexOf(E element, [int start]) => _inner.lastIndexOf(element, start);
  E last() => _inner.last();
  List<E> getRange(int start, int length) => _inner.getRange(start, length);
}