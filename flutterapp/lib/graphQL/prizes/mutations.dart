String claimPrizeMutation(String prizeID, String userID) {
  return """
  mutation claimPrize {
    claimPrize(_prize: "$prizeID", _user: "$userID")
  }
  """;
}