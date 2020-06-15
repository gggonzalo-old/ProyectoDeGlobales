String getEventsQuery(String search) {
  return '''
query getEvents {
	events(filter: "$search") {
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
