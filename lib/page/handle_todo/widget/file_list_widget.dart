import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

Widget fileListWidget(List<String> list) {
  return ImageSlideshow(
    width: double.infinity,
    height: 200,
    children: List.generate(
      list.length,
      (index) => Center(
        child: Hero(
          tag: "TNT",
          child: Image.file(
            File(list[index]),
          ),
        ),
      ),
    ),
  );
}
