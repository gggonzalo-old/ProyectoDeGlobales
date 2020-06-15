String toggleLikePostMutation(String userId, String postId) {
  return """ 
  mutation toggleLike {
  toggleUserPostLike(_user: "$userId", _post: "$postId") {
    _id
    date
    description
    imageUrl
    comments {
      content
      user {
        _id
        username
        name
        photoUrl
      }
      date
    }
    usersWhoLiked {
      _id
      username
      name
      photoUrl
    }
  }
}
  """;
}

String createCommentPostMutation(String id, String comment) {
  return """ 
    query getUsers {
      users(_post: "$id") {
        _id,
        username,
        name,
        photoUrl,
        isFriend
      }
    }
  """;
}
