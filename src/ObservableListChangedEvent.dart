typedef void ObservableListChangedListener<T>(ObservableListChangedEvent<T> event);

class ObservableListChangedEvent<T> {
   final ObservableList<T> list;

   ObservableListChangedEvent(ObservableList<T> this.list);
}