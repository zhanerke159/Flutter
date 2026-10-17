import 'package:flutter/material.dart';

import '../models/movie_category.dart';
import '../models/movie_event.dart';

class FormScreen extends StatefulWidget {
  final MovieEvent? movie;

  const FormScreen({super.key, this.movie});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _limitController;
  late final TextEditingController _placeController;
  late final TextEditingController _descriptionController;

  late final FocusNode _titleFocus;
  late final FocusNode _limitFocus;
  late final FocusNode _placeFocus;
  late final FocusNode _descriptionFocus;

  late MovieCategory _category;
  late DateTime _when;
  late bool _online;

  late final String _initialTitle;
  late final String _initialLimit;
  late final String _initialPlace;
  late final String _initialDescription;
  late final MovieCategory _initialCategory;
  late final DateTime _initialWhen;
  late final bool _initialOnline;

  bool _isSaving = false;
  bool _allowPop = false;
  bool _dirty = false;

  bool get _isEditing => widget.movie != null;

  @override
  void initState() {
    super.initState();

    final movie = widget.movie;

    _titleController = TextEditingController(text: movie?.title ?? '');

    _limitController = TextEditingController(
      text: movie?.limit.toString() ?? '',
    );

    _placeController = TextEditingController(text: movie?.place ?? '');

    _descriptionController = TextEditingController(
      text: movie?.description ?? '',
    );

    _titleFocus = FocusNode();
    _limitFocus = FocusNode();
    _placeFocus = FocusNode();
    _descriptionFocus = FocusNode();

    _category = movie?.category ?? MovieCategory.action;
    _when = movie?.when ?? DateTime.now().add(const Duration(days: 1));
    _online = movie?.online ?? false;

    _initialTitle = _titleController.text.trim();
    _initialLimit = _limitController.text.trim();
    _initialPlace = _placeController.text.trim();
    _initialDescription = _descriptionController.text.trim();
    _initialCategory = _category;
    _initialWhen = _when;
    _initialOnline = _online;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _limitController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();

    _titleFocus.dispose();
    _limitFocus.dispose();
    _placeFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  bool _calculateDirty() {
    return _titleController.text.trim() != _initialTitle ||
        _limitController.text.trim() != _initialLimit ||
        _placeController.text.trim() != _initialPlace ||
        _descriptionController.text.trim() != _initialDescription ||
        _category != _initialCategory ||
        _when != _initialWhen ||
        _online != _initialOnline;
  }

  void _refreshDirty() {
    final newDirty = _calculateDirty();

    if (newDirty == _dirty) {
      return;
    }

    setState(() {
      _dirty = newDirty;
    });
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) {
      return true;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
            'You have unsaved changes. Do you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return discard ?? false;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);

    final initialDate = _when.isBefore(firstDate) ? firstDate : _when;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null || !mounted) {
      return;
    }

    setState(() {
      _when = DateTime(
        date.year,
        date.month,
        date.day,
        _when.hour,
        _when.minute,
      );

      _dirty = _calculateDirty();
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );

    if (time == null || !mounted) {
      return;
    }

    setState(() {
      _when = DateTime(
        _when.year,
        _when.month,
        _when.day,
        time.hour,
        time.minute,
      );

      _dirty = _calculateDirty();
    });
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (!_isEditing && !_when.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date and time must be in the future')),
      );

      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    final description = _descriptionController.text.trim();
    final oldMovie = widget.movie;

    final movie = MovieEvent(
      title: _titleController.text.trim(),
      category: _category,
      when: _when,
      limit: int.parse(_limitController.text.trim()),
      viewers: oldMovie?.viewers ?? const [],
      online: _online,
      place: _placeController.text.trim(),
      description: description.isEmpty ? null : description,
      favourite: oldMovie?.favourite ?? false,
    );

    setState(() {
      _isSaving = false;
      _allowPop = true;
    });

    await Future<void>.delayed(Duration.zero);

    if (!mounted) {
      return;
    }

    Navigator.pop(context, movie);
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop || !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final navigator = Navigator.of(context);
        final discard = await _confirmDiscard();

        if (!mounted || !discard) {
          return;
        }

        _allowPop = true;
        navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Edit Movie' : 'Add Movie')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocus,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  _refreshDirty();
                },
                onFieldSubmitted: (_) {
                  _limitFocus.requestFocus();
                },
                onTapOutside: (_) {
                  _unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final title = value?.trim() ?? '';

                  if (title.length < 3) {
                    return 'Title must have at least 3 characters';
                  }

                  if (title.length > 60) {
                    return 'Title must have at most 60 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MovieCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final category in MovieCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon),
                          const SizedBox(width: 8),
                          Text(category.label),
                        ],
                      ),
                    ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Choose a category';
                  }

                  return null;
                },
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _category = value;
                    _dirty = _calculateDirty();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                focusNode: _limitFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  _refreshDirty();
                },
                onFieldSubmitted: (_) {
                  _placeFocus.requestFocus();
                },
                onTapOutside: (_) {
                  _unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Viewer limit',
                  hintText: 'For example: 20',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final limit = int.tryParse(value?.trim() ?? '');

                  if (limit == null) {
                    return 'Enter a number';
                  }

                  if (limit < 1 || limit > 500) {
                    return 'Limit must be from 1 to 500';
                  }

                  if (_isEditing && limit < (widget.movie?.count ?? 0)) {
                    return 'Limit cannot be less than current viewers';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: ValueKey('date-$_when'),
                initialValue: '${_when.day}.${_when.month}.${_when.year}',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose a date';
                  }

                  return null;
                },
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: ValueKey('time-$_when'),
                initialValue:
                    '${_when.hour.toString().padLeft(2, '0')}:'
                    '${_when.minute.toString().padLeft(2, '0')}',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose a time';
                  }

                  return null;
                },
                onTap: _pickTime,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Online screening'),
                subtitle: Text(
                  _online
                      ? 'Movie will be watched online'
                      : 'Movie will be watched in person',
                ),
                value: _online,
                onChanged: (value) {
                  setState(() {
                    _online = value;
                    _dirty = _calculateDirty();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placeController,
                focusNode: _placeFocus,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  _refreshDirty();
                },
                onFieldSubmitted: (_) {
                  _descriptionFocus.requestFocus();
                },
                onTapOutside: (_) {
                  _unfocus();
                },
                decoration: InputDecoration(
                  labelText: _online ? 'Meeting link' : 'Cinema / room',
                  hintText: _online
                      ? 'https://example.com/watch'
                      : 'For example: Cinema Hall 1',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final place = value?.trim() ?? '';

                  if (place.isEmpty) {
                    return _online
                        ? 'Enter a meeting link'
                        : 'Enter a cinema or room';
                  }

                  if (_online && !place.contains('://')) {
                    return 'Link must contain ://';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                focusNode: _descriptionFocus,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onChanged: (_) {
                  _refreshDirty();
                },
                onFieldSubmitted: (_) {
                  _descriptionFocus.unfocus();
                },
                onTapOutside: (_) {
                  _unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Write something about the screening',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
