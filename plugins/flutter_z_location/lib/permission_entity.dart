class PermissionEntity {
  final String code;
  final String message;
  bool get hasSuccess => code == '00000';

  const PermissionEntity({
    required this.code,
    required this.message,
  });

  factory PermissionEntity.fromMap(Map<dynamic, dynamic> map) {
    return PermissionEntity(
      code: map['code'].toString(),
      message: map['message'].toString(),
    );
  }

  @override
  String toString() {
    return 'PermissionEntity{code: $code, message: $message}';
  }
}
