String toggleEventEnrollmentMutation(String userID, String eventID) {
  return """ 
    mutation toggleEventEnrollment {
      toggleEventEnrollment(_post: "$eventID", _user: "$userID")
    }
  """;
}
