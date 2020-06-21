String getUsersQuery(String id, String filter) {
  return """ 
    query getUsers {
      users(_user: "$id", filter: "$filter") {
        _id
        username
        name
        photoURL
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
        photoURL
        points
        posts {
          _id
          date
          description
          imageURL
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
              photoURL
            }
          }
        }
        prizesClaimed {
          _id
          QRURL
        }
        friends {
          _id
        }
        enrolledEvents {
          _id 
          name
          imageURL
        }
      }
    }
  """;
}

String getUserTagsQuery(String id) {
  return """ 
    query getUser {
      user(_user: "$id") {
        eventTags
      }
    }
  """;
}
