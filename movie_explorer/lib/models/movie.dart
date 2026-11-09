import 'package:flutter/material.dart';

// A user review for a movie.
class Review {
  final String name;
  final int rating; // 1 to 5
  final String comment;

  const Review({required this.name, required this.rating, required this.comment});
}

// A movie. "poster" is a colour used to draw a gradient poster (no image files needed).
class Movie {
  final int id;
  final String title;
  final int year;
  final String genre;
  final double rating;
  final String description;
  final Color poster;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    required this.description,
    required this.poster,
  });
}
