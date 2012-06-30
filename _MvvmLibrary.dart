#library('elcoma:mvvm');

#import('dart:core');
#import('dart:html');
#import('dart:json');

#import('../_CommonLibrary.dart');

#source('PropertyChangedEvent.dart');
#source('ListChangedEvent.dart');
#source('ViewModel.dart');
#source('ListViewModel.dart');
#source('BindingDescription.dart');
#source('Converters/BindingConverter.dart');
#source('Converters/IntegerConverter.dart');
#source('Converters/DoubleConverter.dart');
#source('Converters/BooleanConverter.dart');
#source('Converters/NormalizedStringConverter.dart');
#source('Converters/GuidConverter.dart');
#source('Validators/ValidationError.dart');
#source('Validators/BindingValidator.dart');
#source('Validators/IntegerValidator.dart');
#source('Validators/DoubleValidator.dart');
#source('Validators/BooleanValidator.dart');
#source('Bindings/BindingBase.dart');
#source('Bindings/ValueBinding.dart');
#source('Bindings/ClickBinding.dart');
#source('Bindings/TextBinding.dart');
#source('Bindings/TriStateBinding.dart');
#source('Bindings/VisibilityBinding.dart');
#source('Bindings/ForeachBinding.dart');
#source('BindingGroup.dart');
#source('ViewModelBinder.dart');