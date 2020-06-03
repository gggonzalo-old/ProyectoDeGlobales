class Comment {
  String authorName;
  String authorImageUrl;
  String text;

  Comment({
    this.authorName,
    this.authorImageUrl,
    this.text,
  });
}

final List<Comment> comments = [
  Comment(
    authorName: 'Fazio',
    authorImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
    text: 'Loving this photo!!',
  ),
  Comment(
    authorName: 'Alonso',
    authorImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
    text: 'One of the best photos of you...',
  ),
  Comment(
    authorName: 'Cosi',
    authorImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
    text: 'Can\'t wait for you to post more!',
  ),
  Comment(
    authorName: 'Erick',
    authorImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
    text: 'Nice job',
  ),
  Comment(
    authorName: 'Gonzalo',
    authorImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
    text: 'Thanks everyone :)',
  ),
];
