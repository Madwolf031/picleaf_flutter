import 'package:flutter/material.dart';
import 'package:picleaf/widgets/plant.dart';
import '../widgets/card.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _HomePageState();
}

const List<String> plants = [
  "Bell Pepper",
  "Cassava",
  "Grape",
  "Potato",
  "Strawberry",
  "Tomato",
];

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({String hinttext = "Search topics here..."})
      : super(searchFieldLabel: hinttext);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromRGBO(47, 79, 79, 1.0),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(102, 204, 102, 1.0)),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color.fromRGBO(102, 204, 102, 1.0),
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in plants) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
            style: const TextStyle(
                fontFamily: 'RobotoMedium',
                color: Color.fromRGBO(47, 79, 79, 1.0)),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SecondPage(plantname: result)));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in plants) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
            style: const TextStyle(
                fontFamily: 'RobotoMedium',
                color: Color.fromRGBO(47, 79, 79, 1.0)),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SecondPage(plantname: result)));
          },
        );
      },
    );
  }
}

class _HomePageState extends State<homePage> {
  List<Widget> getPlantList() {
    List<Widget> plantitems = [];
    for (int i = 0; i < plants.length; i++) {
      String plant = plants[i];
      String imgname = i.toString();
      var newItem = ListViewCard(
        title: plant,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SecondPage(plantname: plant)));
        },
        imageOfPlant: "assets/Images_of_Plant/$imgname.png",
      );
      plantitems.add(newItem);
    }
    return plantitems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Take a pic!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontFamily: 'RobotoBold',
                        color: const Color.fromRGBO(102, 204, 102, 1.0)),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Find out what is wrong with your plant!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'RobotoMedium',
                        color: const Color.fromRGBO(47, 79, 79, 1.0)),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return getPlantList()[index];
                },
                childCount: plants.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    (MediaQuery.of(context).size.height / 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
