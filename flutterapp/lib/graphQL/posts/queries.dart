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
          date 
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
    usersWhoLiked {
    	_id
      username
      photoUrl
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
    owner {
      _id
      username
      name
      photoUrl
    }
  }
}
''';
}

String getPostsByHashtagQuery(String tag) {
  return '''
query getPostsByHashtag {
	posts(tag: "$tag") {
    _id
    imageUrl
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
