String getHomePostsQuery(String userId) {
  return '''
query getHomePosts {
	user(_currentUser: "$userId", _user: "$userId") {
    bookmarkedPosts {
      _id
      imageURL
    }
    friends {
      _id
      username
      name
      photoURL
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
    imageURL
    eventTag
    verified
    usersWhoLiked {
    	_id
      username
      photoURL
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
    owner {
      _id
      username
      name
      photoURL
    }
  }
}
''';
}

String getPostsByHashtagQuery(String tag) {
  return '''
query getPostsByHashtag {
	posts(eventTag: "$tag") {
    _id
    imageURL
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
