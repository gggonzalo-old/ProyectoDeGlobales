String getHomePostsQuery(String userId) {
  return '''
query getUsers {
	user(_user: "$userId") {
    friends {
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
    }
  }
}
''';
}

String getPostQuery(String id) {
  return '''
query getPost {
	post(_post: "$id") {
    _id
    date 
    description
    imageUrl
    comments
    userWhoLiked
  }
}
''';
}

String getPostsByHashtagQuery(String userId, String search) {
  return '''
query getPost {
	post(_id: "$userId") {
    
  }
}
''';
}

/*
        comments {
          user {
            username
          }
          content 
        }*/
