String getEventsQuery(String search) {
  return '''
query getEvents {
	events(filter: "$search") {
    _id
    name
    date 
    price
    place
    imageUrl
  }
}
''';
}

String getEventQuery(String id) {
  return '''
query getEvent {
	event(_event: "$id") {
    _id
    name
    description
    date 
    price
    place
    imageUrl
    usersEnrolled {
      _id
      username
      photoUrl
    }
    usersInterested {
      _id
      username
      photoUrl
    }
    owner {
      _id
      name
      description
      imageUrl
    }
  }
}
''';
}