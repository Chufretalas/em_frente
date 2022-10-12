extension MyDateTime on DateTime {
  int lengthOfMonth() {
    return DateTime(year, month + 1, 0).day;
  }
}