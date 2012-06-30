typedef void PropertyChangedListener(PropertyChangedEvent event);

class PropertyChangedEvent {
  ViewModel _viewModel;
  String _propertyName;
  Object _oldValue;
  Object _newValue;

  ViewModel get viewModel() => _viewModel;
  String get propertyName() => _propertyName;
  Object get oldValue() => _oldValue;
  Object get newValue() => _newValue;

  PropertyChangedEvent(ViewModel viewModel, String propertyName, Object oldValue, Object newValue)
    : _viewModel = viewModel, _propertyName = propertyName, _oldValue = oldValue, _newValue = newValue
  {
  }
}