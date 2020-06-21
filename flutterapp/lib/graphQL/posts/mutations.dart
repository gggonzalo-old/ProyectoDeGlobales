String toggleLikePostMutation(String userId, String postId) {
  return """ 
  mutation toggleLike {
  toggleUserPostLike(_user: "$userId", _post: "$postId") 
}
  """;
}

String createUserPostMutation(String userID, String description, String eventTag, String imageURL) {
  return """
  mutation createUserPost {
    createUserPost(_user: "$userID", description: "$description", eventTag: "$eventTag", imageURL: "$imageURL")
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
