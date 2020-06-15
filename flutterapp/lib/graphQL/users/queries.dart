String getUsersQuery(String id, String filter) {
  return """ 
    query getUsers {
      users(_user: "$id", filter: "$filter") {
        _id
        username
        name
        photoUrl
        isFriend
      }
    }
  """;
}

String getUserQuery(String id) {
  return """ 
    query getUser {
      user(_user: "$id") {
        _id
        username
        name
        photoUrl
        posts {
          _id
          date
          description
          imageUrl
          usersWhoLiked {
            _id
            username
          }
          comments {
            content
            date 
            user {
              _id
              username
              photoUrl
            }
          }
        }
        friends {
          _id
        }
        enrolledEvents{
          _id 
        }
      }
    }
  """;
}
