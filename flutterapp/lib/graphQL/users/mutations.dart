String createUserMutation(String username, String name) {
  return """
mutation createUser {
  createUser(
    	username: $username, 
    	name: $name
  )
  {
    username
  }
} 
""";
}
