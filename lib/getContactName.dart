class getContactName {
  String contactName = '';

  String getName(String recievedMessage) {
    contactName = recievedMessage[5].toUpperCase();
    for (int i = 6; i < recievedMessage.length; i++) {
      contactName += recievedMessage[i].toLowerCase();
    }
    return contactName;
  }
}
