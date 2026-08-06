class EmployeeModel {
  int? status;
  int? errorCode;
  String? message;
  EmployeeData? data;

  EmployeeModel({
    this.status,
    this.errorCode,
    this.message,
    this.data,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      status: json['status'],
      errorCode: json['errorCode'],
      message: json['message'].toString(),
      data: json['data'] != null
          ? EmployeeData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'errorCode': errorCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class EmployeeData {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;
  String? age;
  String? gender;
  String? availableBalance;
  String? availableProgram;
  String? createdAt;
  String? updatedAt;

  EmployeeData({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.gender,
    this.availableBalance,
    this.availableProgram,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'],
      firstName: json['first_name'].toString(),
      lastName: json['last_name'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      age: json['age'].toString(),
      gender: json['gender'].toString(),
      availableBalance: json['available_balance'].toString(),
      availableProgram: json['available_program'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'available_balance': availableBalance,
      'available_program': availableProgram,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}