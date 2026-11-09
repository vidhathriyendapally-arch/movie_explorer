import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
if (args is! Movie) return const HomeScreen();
final movie = args;

    return Scaffold(
      appBar: AppBar(title: Text('Review: ${movie.title}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Your name', border: OutlineInputBorder()),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter your name';
                    if (v.trim().length < 2) return 'Name is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ratingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Rating (1 to 5)', border: OutlineInputBorder()),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter a rating';
                    final n = int.tryParse(v.trim());
                    if (n == null) return 'Enter a whole number';
                    if (n < 1 || n > 5) return 'Rating must be between 1 and 5';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: 'Comment', border: OutlineInputBorder()),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please write a comment';
                    if (v.trim().length < 10) return 'Write at least 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _submit(movie),
                  child: const Text('Submit Review'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
