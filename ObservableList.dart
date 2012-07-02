class ObservableList<E> implements List {
  List<E> _inner;
  List<ObservableListChangedListener> _listListeners;

  ObservableList([int length]) {
    _listListeners = new List<ObservableListChangedListener>();
    _inner = new List(length);
  }

  ObservableList.from(Iterable<E> other) {
    _listListeners = new List<ObservableListChangedListener>();
    _inner = new List.from(other);
  }

  void addHandler(ObservableListChangedListener listener) {
    _listListeners.add(listener);
  }

  void removeHandler(ObservableListChangedListener listener) {
    int oldCount = _listListeners.length;
    int index = _listListeners.indexOf(listener);

    if (index >= 0) {
      _listListeners.removeRange(index, 1);
    }
    // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
    assert(oldCount > _listListeners.length);
  }

  void _notifyListListeners() {
    //TODO: add more details to event, so the listener must not rescan the list
    ObservableListChangedEvent event = new ObservableListChangedEvent(this);

    _listListeners.forEach((ObservableListChangedListener l) => l(event));
  }

  void replaceWith(Collection<E> items) {
    _inner.clear();
    _inner.addAll(items);
    _notifyListListeners();
  }

  void operator []=(int index, E value) {
    _inner[index] = value;
    _notifyListListeners();
  }

  void set length(int newLength) {
    _inner.length = newLength;
    _notifyListListeners();
  }

  void add(E value) {
    _inner.add(value);
    _notifyListListeners();
  }

  void addLast(E value) {
    _inner.add(value);
    _notifyListListeners();
  }
  void addAll(Collection<E> collection) {
    _inner.addAll(collection);
    _notifyListListeners();
  }

  void sort(int compare(E a, E b)) {
    _inner.sort(compare);
    _notifyListListeners();
  }

  void clear() {
    _inner.clear();
    _notifyListListeners();
  }

  E removeLast() {
    E item = _inner.removeLast();
    _notifyListListeners();
    return item;
  }

  void setRange(int start, int length, List<E> from, [int startFrom]) {
    _inner.setRange(start, length, from, startFrom);
    _notifyListListeners();
  }

  void removeRange(int start, int length) {
    _inner.removeRange(start, length);
    _notifyListListeners();
  }

  void insertRange(int start, int length, [E initialValue]) {
    _inner.insertRange(start, length, initialValue);
    _notifyListListeners();
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
  String toString() => _inner.toString();
}