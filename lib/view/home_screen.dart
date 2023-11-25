import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quadbapp/view/details_page.dart';
import 'package:quadbapp/view/searchpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //list for different categories.
  List<Map<String, dynamic>> shows = [];
  List<Map<String, dynamic>> topFiveShows = [];
  List<Map<String, dynamic>> comedyShows = [];
  List<Map<String, dynamic>> dramaShows = [];
  List<Map<String, dynamic>> sportShows = [];

  @override
  void initState() {
    super.initState();
    // fetching data when initialized.
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.tvmaze.com/search/shows?q=all')); //API to get data

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        shows = List<Map<String, dynamic>>.from(
            data.map((dynamic x) => x as Map<String, dynamic>));
        //stroing data in various list to render them on screen accordingly
        topFiveShows = getTopFiveShows();
        comedyShows = getComedyShows();
        dramaShows = getDramaShows();
        sportShows = getSportShows();
      });
    } else {
      // throw Exception('Failed to load data');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Some error occurred!'),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 4),
      ));
    }
  }

  //functions to get data accordingly
  List<Map<String, dynamic>> getTopFiveShows() {
    if (shows.length > 5) {
      List<Map<String, dynamic>> sortedShows = List.from(shows);
      sortedShows.sort((a, b) => b['score'].compareTo(a['score']));
      return sortedShows.take(5).toList();
    } else {
      return shows;
    }
  }

  List<Map<String, dynamic>> getComedyShows() {
    return shows
        .where((show) =>
            (show['show']['genres'] as List<dynamic>).contains('Comedy'))
        .toList();
  }

  List<Map<String, dynamic>> getDramaShows() {
    return shows
        .where((show) =>
            (show['show']['genres'] as List<dynamic>).contains('Drama'))
        .toList();
  }

  List<Map<String, dynamic>> getSportShows() {
    return shows
        .where((show) =>
            (show['show']['genres'] as List<dynamic>).contains('Sports'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        leadingWidth: 85,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 5, 5, 5),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'assets/QuadB.png',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    " Today's special ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              // Carousel Slider for trending shows
              topFiveShows != null
                  ? CarouselSlider(
                      items: topFiveShows
                          .map<Widget>((show) => _buildShowCard(show))
                          .toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF831010),
                      ),
                    ),

              const SizedBox(
                height: 28,
              ),
              //All Comedy Show here
              Row(
                children: const [
                  Text(
                    ' best in comedy ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              comedyShows != null
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: comedyShows.length,
                        itemBuilder: (context, index) {
                          return _buildGeneralShowCard(comedyShows[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF831010),
                      ),
                    ),

              const SizedBox(
                height: 28,
              ),
              //All Drama Show here
              Row(
                children: const [
                  Text(
                    ' best in drama ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              dramaShows != null
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dramaShows.length,
                        itemBuilder: (context, index) {
                          return _buildGeneralShowCard(dramaShows[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF831010),
                      ),
                    ),

              const SizedBox(
                height: 28,
              ),
              //All Sports Show here
              Row(
                children: const [
                  Text(
                    ' best in sports ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              sportShows != null
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sportShows.length,
                        itemBuilder: (context, index) {
                          return _buildGeneralShowCard(sportShows[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF831010),
                      ),
                    ),

              // showing all shows here
              const SizedBox(
                height: 28,
              ),
              Row(
                children: const [
                  Text(
                    ' All Shows ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              shows != null
                  ? SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shows.length,
                        itemBuilder: (context, index) {
                          return _buildGeneralShowCard(shows[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF831010),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //widgets
  Widget _buildShowCard(Map<String, dynamic> show) {
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(show['show']['image']['original']),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                show['show']['name'],
                style: const TextStyle(
                  fontSize: 28,
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

  Widget _buildGeneralShowCard(Map<String, dynamic> show) {
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(show['show']['image']['original']),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                show['show']['name'],
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
