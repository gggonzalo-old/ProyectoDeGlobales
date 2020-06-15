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

String createCommentPostMutation(String postID, String userID, String comment) {
  return """ 
    mutation createComment {
      commentUserPost(_post: "$postID", _user: "$userID", content: "$comment")
    }
  """;
}
