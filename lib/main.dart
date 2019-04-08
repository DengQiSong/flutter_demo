import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: RandomWords(),
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
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Startup Name Generator"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushLayout)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return new Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
        if (index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },);
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
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

  void _pushSaced() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
          final tiles = _saved.map((pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          });
          final divided = ListTile.divideTiles(context: context, tiles: tiles)
              .toList();
          return new Scaffold(
            appBar: new AppBar(
              title: new Text("Saved Suggestions"),
            ),
            body: new ListView(children: divided),
          );
        })
    );
  }

  void _pushLayout() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new LayoutWidget()));
  }


}

class LayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
          children: [new Expanded(child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text("Oeschinen Lake Campground",
                style: new TextStyle(
                    fontWeight: FontWeight.bold
                ),),
            ),
            new Text("Kandersteg, Switzerland",
              style: new TextStyle(
                  color: Colors.grey[500]
              ),)
            ],
          )),
          new Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          new Text("41")
          ]
      ),
    );
    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme
          .of(context)
          .primaryColor;
      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(icon, color: color),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }
    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );
    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Flutter Layout"),
          centerTitle: true,
        ),
      body: new ListView(
        children: <Widget>[
          new Image.asset(
            "images/main_head.png",
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
          titleSection,
          buttonSection,
          textSection
        ],
      ),
    );
  }
}
