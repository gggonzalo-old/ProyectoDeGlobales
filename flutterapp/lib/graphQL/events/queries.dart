String getEventsQuery(String search) {
  return '''
query getEvents {
	events(filter: "$search") {
    _id
    name
    date 
    price
    place
    imageURL
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
    imageURL
    usersEnrolled {
      _id
      username
      photoURL
    }
    usersInterested {
      _id
      username
      photoURL
    }
    owner {
      _id
      name
    }
  }
}
''';
}