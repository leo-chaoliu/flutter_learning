import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // title: 'Startup Name Generator',
      // home routing
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // each row
    Widget _buildRow(WordPair pair) {
      final alreadySaved = _saved.contains(pair);

      return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.indigo : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }

    // list view
    Widget _buildSuggestions() {
      return new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            // Add a one-pixel-high divider widget before each row in theListView.
            if (i.isOdd) return new Divider();
            // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
            // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
            // This calculates the actual number of word pairings in the ListView,
            // minus the divider widgets.
            final index = i ~/ 2;

            // If you've reached the end of the available word pairings...
            if (index >= _suggestions.length) {
              // ...then generate 10 more and add them to the suggestions list.
              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index]);
          });
    }

    void _pushSaved() {
      // navigator is the statefull widget
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) {
            final tiles = _saved.map(
              (pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final divided = ListTile
                .divideTiles(
                  context: context,
                  tiles: tiles,
                )
                .toList();

            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          },
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Namde Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
