import 'package:flutter/material.dart';

class SubCategoryDesignDetailsScreen extends StatefulWidget {
  const SubCategoryDesignDetailsScreen({super.key});

  @override
  State<SubCategoryDesignDetailsScreen> createState() =>
      _SubCategoryDesignDetailsScreenState();
}

class _SubCategoryDesignDetailsScreenState
    extends State<SubCategoryDesignDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sub-Category Details Screen'),
      ),
    );
  }
}
