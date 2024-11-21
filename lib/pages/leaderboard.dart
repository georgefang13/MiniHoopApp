// leaderboard is a page of user cards, ordered by shooting percentage (or alphabetically?)
// also contains a search bar

import 'package:flutter/material.dart';
import 'package:mini_hoop_app/widgets/player_card.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shot Performance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO: modify to pull AWS data
            PlayerCard(
                name: 'George', color: Colors.black, shots: 30, makes: 20),
            PlayerCard(name: 'Luke', color: Colors.brown, shots: 25, makes: 15),
            PlayerCard(
                name: 'Gavin', color: Colors.green, shots: 35, makes: 28),
          ],
        ),
      ),
    );
  }
}

// STATEFUL WIDGET example for http get request
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
 
// class _HomePageState extends State<HomePage> {
// //Applying get request.
 
//   Future<List<User>> getRequest() async {
//     //replace your restFull API here.
//     String url = "https://jsonplaceholder.typicode.com/posts";
//     final response = await http.get(Uri.parse(url));
 
//     var responseData = json.decode(response.body);
 
//     //Creating a list to store input data;
//     List<User> users = [];
//     for (var singleUser in responseData) {
//       User user = User(
//           id: singleUser["id"],
//           userId: singleUser["userId"],
//           title: singleUser["title"],
//           body: singleUser["body"]);
 
//       //Adding user to the list.
//       users.add(user);
//     }
//     return users;
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Http Get Request."),
//           leading: Icon(
//             Icons.get_app,
//           ),
//         ),
//         body: Container(
//           padding: EdgeInsets.all(16.0),
//           child: FutureBuilder(
//             future: getRequest(),
//             builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//               if (snapshot.data == null) {
//                 return Container(
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               } else {
//                 return ListView.builder(
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (ctx, index) => ListTile(
//                     title: Text(snapshot.data[index].title),
//                     subtitle: Text(snapshot.data[index].body),
//                     contentPadding: EdgeInsets.only(bottom: 20.0),
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }