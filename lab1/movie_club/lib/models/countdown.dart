sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  final Duration duration;

  const Upcoming(this.duration);
}

class Started extends Countdown {
  final Duration duration;

  const Started(this.duration);
}

class Ended extends Countdown {
  const Ended();
}

Countdown getCountdown(DateTime movieTime) {
  final now = DateTime.now();

  if (now.isBefore(movieTime)) {
    return Upcoming(movieTime.difference(now));
  }

  final endTime = movieTime.add(const Duration(hours: 2));

  if (now.isBefore(endTime)) {
    return Started(now.difference(movieTime));
  }

  return const Ended();
}
