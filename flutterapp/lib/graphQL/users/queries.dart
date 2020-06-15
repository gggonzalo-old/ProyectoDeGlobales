String readUsers(String id, String filter) {
  return """ 
    query getUsers {
      users(_user: "$id", filter: "$filter") {
        _id,
        username,
        name,
        photoUrl,
        isFriend
      }
    }
  """;
}
