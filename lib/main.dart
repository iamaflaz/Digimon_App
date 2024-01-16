import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Digimon',
      home: DigimonListScreen(),
      );
    }
   }
class DigimonListScreen extends StatefulWidget {
  @override
_DigimonListScreenState createState() => _DigimonListScreenState();
}
class _DigimonListScreenState extends State<DigimonListScreen> {
  late Future<List<Digimon>> digimonList;
  @override
  void initState() {
    super.initState();
    digimonList = fetchDigimonList();
    }
    Future<List<Digimon>> fetchDigimonList() async {
      final response =
      await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Digimon.fromJson(json)).toList();
        }else {
          throw Exception('Failed to load Digimon list');
          }
          }
          Future<Uint8List> fetchImage(String imageUrl) async {
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              return response.bodyBytes;
              } else {
                throw Exception('Failed to load image');
                }
                }
                @override
                Widget build(BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Daftar Digimon'),
                      ),
                      body: FutureBuilder(
                        future: digimonList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<Digimon> data = snapshot.data as List<Digimon>;
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: FutureBuilder(
                                        future: fetchImage(data[index].image),
                                        builder: (context, imageSnapshot) {
                                          if (imageSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                            } else if (imageSnapshot.hasError) {
                                              return Icon(Icons.error);
                                              } else {
                                                return Image.memory(imageSnapshot.data as Uint8List);
                                                }
                                                },
                                                ),
                                                title: Text(data[index].name),
                                                subtitle: Text('Level: ${data[index].level}'),
                                                );
                                                },
                                                );
                                                }
                                                },
                                                ),
                                                );
                                                }
                                                }
class Digimon {
  final String name;
  final String image;
  final String level;
  Digimon({
    required this.name,
    required this.image,
    required this.level,
    });
    factory Digimon.fromJson(Map<String, dynamic> json) {
      return Digimon(
        name: json['name'],
        image: json['img'],
        level: json['level'],
);
}
}