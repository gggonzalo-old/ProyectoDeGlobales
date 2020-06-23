String getOrganizerQuery(String id) {
  return """ 
    query getOrganizer {
      organizer(_organizer: "$id") {
        _id
        name
        description
        imageURL
        events {
          _id
          name
          imageURL
        }
      }
    }
  """;
}