interface ViewModelWithValidationErrors extends ViewModel {
  ListViewModel<ValidationError> get validationErrors();
}