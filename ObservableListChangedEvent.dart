typedef void ObservableListChangedListener<T>(ObservableListChangedEvent<T> event);

class ObservableListChangedEvent<T> {
   ObservableList<T> _list;

   ObservableList<T> get list() => _list;

   ObservableListChangedEvent(ObservableList<T> list) : _list = list {

   }
}