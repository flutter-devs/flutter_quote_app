import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quote_app/models/qoutemodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController pageController = PageController(keepPage: true);

class _HomeScreenState extends State<HomeScreen> {
// call the API and fetch the response
  static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('Failed to load Quote');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: FutureBuilder<List<Quotes>>(
              future: fetchQuotes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Quotes>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return buildPageView(snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Made with ❤ by Anubhav",
                style: GoogleFonts.lora(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PageView buildPageView(AsyncSnapshot<List<Quotes>> snapshot) {
    return PageView.builder(
      controller: pageController,
      itemCount: snapshot.data.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.87,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amberAccent[700],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(60),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          margin: EdgeInsets.only(bottom: 10),

          child: Stack(
            children: [
              Text(
                'Quotes App',
                style: GoogleFonts.lobster(fontSize: 45, color: Colors.white),
              ),
              Align(
                alignment: Alignment.center,
                child: TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  displayFullTextOnTap: true,
                  speed: const Duration(milliseconds: 150),
                  onFinished: () {
                    pageController.nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutCirc,
                    );
                  },
                  text: ['"' + snapshot.data[index].q + '"'],
                  textStyle: GoogleFonts.montserratAlternates(
                      fontSize: 30.0, color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  snapshot.data[index].a,
                  style: GoogleFonts.lora(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
