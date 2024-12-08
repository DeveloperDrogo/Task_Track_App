String timeAgo(DateTime dateTime) {
  // Convert both to UTC for consistent calculations
  Duration diff = DateTime.now().difference(dateTime);
  if (diff.isNegative) {
    return "In the future"; // Handle future dates explicitly
  } else if (diff.inSeconds < 60) {
    return '${diff.inSeconds} seconds ago';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} days ago';
  } else if (diff.inDays < 30) {
    int weeks = (diff.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (diff.inDays < 365) {
    int months = (diff.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    int years = (diff.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}
