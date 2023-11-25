import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadbapp/view/details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isFetchingResults = false;
  late FocusNode _focusNode;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool noResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String searchTerm) async {
    setState(() {
      isFetchingResults = true;
    });
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = List<Map<String, dynamic>>.from(
            data.map((dynamic x) => x as Map<String, dynamic>));
        noResults = searchResults.isEmpty;
      });
    } else {
      // throw Exception('Failed to load search results');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Some error occurred!'),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 4),
      ));
    }
    setState(() {
      isFetchingResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 30, left: 8, right: 8, bottom: 8),
              child: TextFormField(
                focusNode: _focusNode,
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () {
                      // Clearing the text field
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.grey.withOpacity(0.2),
                  filled: true,
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onFieldSubmitted: (value) {
                  String searchTerm = value.trim();
                  _fetchSearchResults(searchTerm);
                },
              ),
            ),
            if (isFetchingResults && _searchController.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            //
            if (_searchController.text.isNotEmpty)
              if (noResults) // Display message when no results are found
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No movies found.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              else if (searchResults.isNotEmpty)
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: searchResults.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildGeneralShowCard(searchResults[index]),
                ),
          ],
        ),
      ),
    );
  }

//widgets
  Widget _buildGeneralShowCard(Map<String, dynamic> show) {
    var showName = show['show']['name'];
    var imageOriginal = show['show']['image'] != null
        ? show['show']['image']['original']
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowDetailPage(show: show),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: imageOriginal != null
              ? DecorationImage(
                  image: NetworkImage(imageOriginal),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showName ?? "Unknown",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
