class ListViewModel<E> implements List {
  List<E> _inner;
  List<ListChangedListener> _listListeners;

  ListViewModel([int length]) {
    _listListeners = new List<ListChangedListener>();
    _inner = new List(length);
  }

  ListViewModel.from(Iterable<E> other) {
    _listListeners = new List<ListChangedListener>();
    _inner = new List.from(other);
  }

  void addHandler(ListChangedListener listener) {
    _listListeners.add(listener);
  }

  void removeHandler(ListChangedListener listener) {
    int index = _listListeners.indexOf(listener);

    if (index >= 0) {
      _listListeners.removeRange(index, 1);
    }
  }

  void _notifyListListeners() {
    //TODO: add more details to event, so the listener must not rescan the list
    ListChangedEvent event = new ListChangedEvent(this);

    _listListeners.forEach((ListChangedListener l) => l(event));
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
}