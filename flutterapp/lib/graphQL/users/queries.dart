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

String getUserQuery(String currentUserID, String userID) {
  return """ 
    query getUser {
      user(_currentUser: "$currentUserID", _user: "$userID") {
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
          name
          description
          cost 
          imageURL
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
        bookmarkedPosts {
          _id
          imageURL
        }
        isFriend
      }
    }
  """;
}

String getUserTagsQuery(String id) {
  return """ 
    query getUser {
      user(_currentUser: "$id", _user: "$id") {
        eventTags
      }
    }
  """;
}

String getUserBookMarkedsPostsQuery(String id) {
  return """ 
    query getUserBookMarkedsPosts {
      user(_currentUser: "$id", _user: "$id") {
        _id
        bookmarkedPosts {
          _id
        }
      }
    }
  """;
}
