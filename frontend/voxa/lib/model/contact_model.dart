class ContactModel {
  final String name;
  final String avatar;
  final bool isOnline;

  ContactModel({
    required this.name,
    required this.avatar,
    this.isOnline = false,
  });
}
