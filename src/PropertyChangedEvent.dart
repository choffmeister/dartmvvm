typedef void PropertyChangedListener(PropertyChangedEvent event);

class PropertyChangedEvent {
  final ViewModel viewModel;
  final String propertyName;

  PropertyChangedEvent(ViewModel this.viewModel, String this.propertyName);
}