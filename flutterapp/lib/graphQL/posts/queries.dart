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
    comments {
      content
      date
      user {
        _id
        username
        photoUrl
      }
    }
    usersWhoLiked {
    	_id
      username
      photoUrl
    }
  }
}
''';
}

String getPostsByHashtagQuery(String tag) {
  return '''
query getPost {
	posts(tag: "$tag") {
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

/*
        comments {
          user {
            username
          }
          content 
        }*/
