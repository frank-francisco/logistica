String timeAgoSinceDateRo(String dateString, {bool numericDates = true}) {
  DateTime date = DateTime.parse(dateString);
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} ani în urmă';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? 'Acum un an' : 'Anul trecut';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 30).floor()} luni în urmă';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? 'Acum o lună' : 'Lună trecută';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} săptămâni în urmă';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? 'Acum o săptămână' : 'Săptămână trecută';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} zile în urmă';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? 'Acum o zi' : 'Ieri';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} ore în urmă';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? 'Acum o oră' : 'Acum o oră';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minute în urmă';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? 'Acum un minut' : 'Acum un minut';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} secunde în urmă';
  } else {
    return 'Chiar acum';
  }
}
