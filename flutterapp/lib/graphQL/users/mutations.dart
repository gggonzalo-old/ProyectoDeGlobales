String createUserMutation(String id, String username, String name, String photoUrl) {
  return """
mutation createUser {
  createUser(
      _id: "$id", 
    	username: "$username", 
    	name: "$name", 
      photoUrl: "$photoUrl"
  )
  {
    username
  }
} 
""";
}

String addFriendMutation(String id, String friendID) {
  return """
mutation addFriend {
  addFriend(_user: "$id", _friend: "$friendID")
} 
""";
}
