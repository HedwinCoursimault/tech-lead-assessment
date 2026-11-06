class CustomerDto {
  final String? id;
  final String? name;
  final String? email;
  final String? type;
  final String? registrationDate;

  const CustomerDto({
    this.id,
    this.name,
    this.email,
    this.type,
    this.registrationDate,
  });

  CustomerDto.fromJson(Map<String, dynamic> json)
      : id = json["id"] as String?,
        name = json["name"] as String?,
        email = json["email"] as String?,
        type = json["type"] as String?,
        registrationDate = json["registration_date"] as String?;
}
