interface BindingValidator default PassBindingValidator {
  BindingValidator();

  void validate(Object value);
}

class PassBindingValidator implements BindingValidator {
  void validate(Object value) {
    // let everything pass
  }
}