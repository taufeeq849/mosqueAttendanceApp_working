class Validator {
  validatePhoneNumber(String phoneno) {
    Pattern pattern = r'(^\+27[0-9]{9}$)';
    RegExp regExp = new RegExp(pattern);

    if (phoneno.length == 0) {
      return true;
    } else if (regExp.hasMatch(phoneno)) {

      return false;
    }
    return true;
  }
}
