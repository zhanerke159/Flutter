import 'models/movie_event.dart';
import 'models/profile.dart';

class AppRoutes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';

  const AppRoutes._();
}

class DetailArguments {
  final MovieEvent movie;
  final Profile profile;
  final void Function(MovieEvent oldMovie, MovieEvent updatedMovie)
  onMovieChanged;
  final void Function(MovieEvent movie) onMovieDeleted;
  final void Function() onOpenProfile;

  const DetailArguments({
    required this.movie,
    required this.profile,
    required this.onMovieChanged,
    required this.onMovieDeleted,
    required this.onOpenProfile,
  });
}

class FormArguments {
  final MovieEvent? movie;

  const FormArguments({this.movie});
}
