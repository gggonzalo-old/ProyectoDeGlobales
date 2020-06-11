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
