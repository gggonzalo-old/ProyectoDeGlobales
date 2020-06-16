String toggleLikePostMutation(String userId, String postId) {
  return """ 
  mutation toggleLike {
  toggleUserPostLike(_user: "$userId", _post: "$postId") 
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
