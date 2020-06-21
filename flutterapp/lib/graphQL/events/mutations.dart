String toggleEventEnrollmentMutation(String userID, String eventID) {
  return """ 
    mutation toggleEventEnrollment {
      toggleEventEnrollment(_event: "$eventID", _user: "$userID")
    }
  """;
}

String toggleEventInInterestedMutation(String userID, String eventID) {
  return """ 
    mutation toggleEventInInterested {
      toggleEventInInterested(_event: "$eventID", _user: "$userID")
    }
  """;
}
