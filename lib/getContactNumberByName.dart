import 'package:contacts_service/contacts_service.dart';

class getContactNumber {
  Future<String> getContactNumberByName(String name) async {
    List<Contact> val = await ContactsService.getContacts(
      query: name,
      withThumbnails: false,
    );

    if (val.isEmpty) {
      return "";
    }
    var number = val[0].phones;
    if (number != null) {
      return number[0].value.toString();
    }
    return "";
  }
}
