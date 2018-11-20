//import 'package:flutter/material.dart';
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Flutter Demo',
//      theme: new ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
//        // counter didn't reset back to zero; the application is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: new MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => new _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return new Scaffold(
//      appBar: new AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: new Text(widget.title),
//      ),
//      body: new Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: new Column(
//          // Column is also layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug paint" (press "p" in the console where you ran
//          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
//          // window in IntelliJ) to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new Text(
//              'You have pushed the button this many times:',
//            ),
//            new Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}

//import 'package:flutter/material.dart';
//import 'package:english_words/english_words.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Startup Name Generator',
//      theme: new ThemeData(
//        primaryColor: Colors.white
//      ),
//      home: RandomWords(),
//    );
//  }
//}
//
//class RandomWordsState extends State<RandomWords> {
//  final _suggestions = <WordPair>[];
//  final _saved = new Set<WordPair>();
//  final _biggerFont = const TextStyle(fontSize: 18.0);
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Startup Name Generator'),
//        actions: <Widget>[
//          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
//        ],
//      ),
//      body: _buildSuggestions(),
//    );
//  }
//  void _pushSaved() {
//    Navigator.of(context).push(
//      new MaterialPageRoute<void>(
//        builder: (BuildContext context) {
//          final Iterable<ListTile> tiles = _saved.map(
//            (WordPair pair) {
//              return new ListTile(
//                title: new Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final List<Widget> divided = ListTile
//          .divideTiles(
//            context: context,
//            tiles: tiles,
//          )
//          .toList();
//          return Scaffold(
//            appBar: new AppBar(
//              title: const Text('Saved Suggestions'),
//            ),
//            body: new ListView(children: divided,),
//          );
//        },
//      )
//    );
//  }
//  Widget _buildSuggestions() {
//    return ListView.builder(
//      padding: const EdgeInsets.all(16.0),
//      itemBuilder: (context, i) {
//        if(i.isOdd) return Divider();
//        final index = i ~/ 2;
//        if(index >= _suggestions.length) {
//          _suggestions.addAll(generateWordPairs().take(10));
//        }
//        return _buildRow(_suggestions[index]);
//      },
//    );
//  }
//  Widget _buildRow(WordPair pair) {
//    final alreadySaved = _saved.contains(pair);
//    return ListTile(
//      title: Text(
//        pair.asPascalCase,
//        style: _biggerFont,
//      ),
//      trailing: new Icon(
//        alreadySaved ? Icons.favorite : Icons.favorite_border,
//        color: alreadySaved ? Colors.red : null,
//      ),
//      onTap: () {
//        setState(() {
//          if (alreadySaved) {
//            _saved.remove(pair);
//          } else {
//            _saved.add(pair);
//          }
//        });
//      }
//    );
//  }
//}
//
//class RandomWords extends StatefulWidget {
//  @override
//  RandomWordsState createState() => new RandomWordsState();
//}

//import 'package:flutter/material.dart';
//
//class Product {
//  const Product({this.name});
//  final String name;
//}
//
//typedef void CartChangedCallback(Product product, bool inCart);
//
//class ShoppingListItem extends StatelessWidget {
//  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
//      : product = product,
//        super(key: ObjectKey(product));
//
//  final Product product;
//  final bool inCart;
//  final CartChangedCallback onCartChanged;
//
//  Color _getColor(BuildContext context) {
//    // The theme depends on the BuildContext because different parts of the tree
//    // can have different themes.  The BuildContext indicates where the build is
//    // taking place and therefore which theme to use.
//
//    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
//  }
//
//  TextStyle _getTextStyle(BuildContext context) {
//    if (!inCart) return null;
//
//    return TextStyle(
//      color: Colors.black54,
//      decoration: TextDecoration.lineThrough,
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ListTile(
//      onTap: () {
//        onCartChanged(product, !inCart);
//      },
//      leading: CircleAvatar(
//        backgroundColor: _getColor(context),
//        child: Text(product.name[0]),
//      ),
//      title: Text(product.name, style: _getTextStyle(context)),
//    );
//  }
//}
//
//class ShoppingList extends StatefulWidget {
//  ShoppingList({Key key, this.products}) : super(key: key);
//
//  final List<Product> products;
//
//  // The framework calls createState the first time a widget appears at a given
//  // location in the tree. If the parent rebuilds and uses the same type of
//  // widget (with the same key), the framework re-uses the State object
//  // instead of creating a new State object.
//
//  @override
//  _ShoppingListState createState() => _ShoppingListState();
//}
//
//class _ShoppingListState extends State<ShoppingList> {
//  Set<Product> _shoppingCart = Set<Product>();
//
//  void _handleCartChanged(Product product, bool inCart) {
//    setState(() {
//      // When a user changes what's in the cart, we need to change _shoppingCart
//      // inside a setState call to trigger a rebuild. The framework then calls
//      // build, below, which updates the visual appearance of the app.
//
//      if (inCart)
//        _shoppingCart.add(product);
//      else
//        _shoppingCart.remove(product);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Shopping List'),
//      ),
//      body: ListView(
//        padding: EdgeInsets.symmetric(vertical: 8.0),
//        children: widget.products.map((Product product) {
//          return ShoppingListItem(
//            product: product,
//            inCart: _shoppingCart.contains(product),
//            onCartChanged: _handleCartChanged,
//          );
//        }).toList(),
//      ),
//    );
//  }
//}
//
//void main() {
//  runApp(MaterialApp(
//    title: 'Shopping App',
//    home: ShoppingList(
//      products: <Product>[
//        Product(name: 'Eggs'),
//        Product(name: 'Flour'),
//        Product(name: 'Chocolate chips'),
//      ],
//    ),
//  ));
//}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart';
import 'login.dart';
import 'me.dart';
import 'home.dart';
import 'track.dart';
import 'blue.dart';

void main() => runApp(PahalaApp());

class PahalaApp extends StatelessWidget {
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PAHaLA',
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        primarySwatch: Colors.lightGreen,
        primaryColor: Colors.green,
        accentColor: Colors.lime,
      ),
      home: SafeArea(child: Home()),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => WelcomePage(),
        '/blue': (BuildContext context) => FlutterBlueApp(),
      },
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    if(firebaseUser == null){
      Future(() {
        Navigator.of(context).pushNamed('/login');
      });
    }
  }
  final List<Widget> _children = [
    MePage(),
    HomePage(),
    TrackPage(),
  ];
  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Me')   ),
    BottomNavigationBarItem(icon: Icon(Icons.home)          , title: Text('Home') ),
    BottomNavigationBarItem(icon: Icon(Icons.show_chart)    , title: Text('Track')),
  ];
  void onTabTapped(int newIndex) => setState(() {_currentIndex = newIndex;});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      primary: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: onTabTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  PlaceholderWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(color: color,);
  }
}
