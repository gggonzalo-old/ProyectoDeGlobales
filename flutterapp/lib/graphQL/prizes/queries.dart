String getPrizesQuery(String search) {
  return '''
query getPrizes {
	prizes(filter: "$search") {
    _id
    name
    description
    cost
    imageURL
    QRURL
  }
}
''';
}