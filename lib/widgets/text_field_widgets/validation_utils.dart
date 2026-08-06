class ValidationUtils {

  /// 🔹 Common Required Validator
  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    }
    return null;
  }

  /// 🔹 Name
  String? nameValidator(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Enter Name";
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(val)) {
      return "Only alphabets allowed";
    }
    return null;
  }

  /// 🔹 Email
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Email";
    }
    final emailRegex =
    RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter valid Email";
    }
    return null;
  }

  /// 🔹 Company Email (@fembuddy.com only)
  String? companyEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Company Email";
    }

    final emailRegex =
    RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter valid Email";
    }

    if (!value.toLowerCase().endsWith("@fembuddy.com")) {
      return "Email must be @fembuddy.com";
    }

    return null;
  }

  /// 🔹 Phone
  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Phone Number';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  /// 🔹 Age
  String? ageValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "Enter Age";
    } else if (!RegExp(r'^\d+$').hasMatch(val)) {
      return "Age must be numbers only";
    } else if (val.length > 3) {
      return "Age must be max 3 digits";
    }
    return null;
  }

  /// 🔹 PinCode
  String? pinCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Pin Code';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Pin Code must be numbers only';
    } else if (value.length != 6) {
      return 'Pin Code must be 6 digits';
    }
    return null;
  }

  /// 🔹 House / Flat No
  String? houseValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Flat/House Number';
    }
    return null;
  }

  /// 🔹 Address
  String? addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Address';
    } else if (value.trim().length < 10) {
      return 'Address must be at least 10 characters';
    }
    return null;
  }

  /// 🔹 Common Text Validator (City, State, Country)
  String? textOnlyValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return "$fieldName must contain only alphabets";
    }
    return null;
  }

  /// 🔹 City
  String? cityValidator(String? value) {
    return textOnlyValidator(value, "City");
  }

  /// 🔹 State
  String? stateValidator(String? value) {
    return textOnlyValidator(value, "State");
  }

  /// 🔹 Country
  String? countryValidator(String? value) {
    return textOnlyValidator(value, "Country");
  }
}