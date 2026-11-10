import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/poster_box.dart';
import 'home_screen.dart';

// StatefulWidget because the form uses controllers.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit(Movie movie) {
    // validate() runs every validator; true only if all pass.
    if (_formKey.currentState!.validate()) {
      context.read<MovieProvider>().addReview(
            movie.id,
            Review(
              name: _nameController.text.trim(),
              rating: int.parse(_ratingController.text.trim()),
              comment: _commentController.text.trim(),
            ),
          );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Review added!')));
      Navigator.pop(context);
    }
  }

  // Shared look for all three text fields.
  InputDecoration _decoration(String label, {IconData? icon, String? helper}) {
    final scheme = Theme.of(context).colorScheme;
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      labelText: label,
      helperText: helper,
      prefixIcon: icon == null ? null : Icon(icon),
      alignLabelWithHint: true,
      filled: true,
      fillColor: scheme.surface,
      border: border(scheme.outline),
      enabledBorder: border(scheme.outline),
      focusedBorder: border(scheme.primary, 2),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // After a browser refresh the movie is lost, so we go back to Home.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Movie) return const HomeScreen();
    final movie = args;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Review: ${movie.title}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Which movie is being reviewed.
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PosterBox(movie: movie, compact: true),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Write a review',
                            style: TextStyle(
                                fontSize: 13, color: scheme.onSurfaceVariant)),
                        Text(movie.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Form card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scheme.outline),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            _decoration('Your name', icon: Icons.person_outline),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (v.trim().length < 2) return 'Name is too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ratingController,
                        keyboardType: TextInputType.number,
                        decoration: _decoration('Rating (1 to 5)',
                            icon: Icons.star_outline,
                            helper: 'Enter a whole number from 1 to 5'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter a rating';
                          }
                          final n = int.tryParse(v.trim());
                          if (n == null) return 'Enter a whole number';
                          if (n < 1 || n > 5) {
                            return 'Rating must be between 1 and 5';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: _decoration('Comment'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please write a comment';
                          }
                          if (v.trim().length < 10) {
                            return 'Write at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _submit(movie),
                          icon: const Icon(Icons.send),
                          label: const Text('Submit Review'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
