String readHomePosts(String userId) {
  return '''
query getUsers {
	user(_user: $userId) {
    friends {
      username
      name
      imageUrl
      posts {
        _id
        date
        description
        imageUrl
        usersWhoLiked {
          username
        }
      }
    }
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
