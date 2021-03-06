import './player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cricket Cards'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Player> _playerData = Player().playerData;
  var width, height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height-120;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Column(children:[
        SizedBox(height: 10,),
      Text("Bot"),
        //TODO: Change this cards for bot, now its same, just to illustrate prototype
      Container(
        height:this.height/2,
        padding: const EdgeInsets.only(top: 8.0),
        child: StackCard.builder(
          dimension: StackDimension(width: this.width,height:this.height/2),
          itemCount: _playerData.length,
          onSwap: (index) {
            print("Page change to $index");
          },
          itemBuilder: (context, index) {
            Player movie = _playerData[index];
            return _itemBuilder(movie,index);
          },
        ),
      ),
        Text("You"),
        Container(
          height:this.height/2,
          padding: const EdgeInsets.only(top: 8.0),
          child: StackCard.builder(
            dimension: StackDimension(width: this.width,height:this.height/2),
            itemCount: _playerData.length,
            onSwap: (index) {
              print("Page change to $index");
            },
            itemBuilder: (context, index) {
              index=(index+1)%3;
              Player movie = _playerData[index];
              return _itemBuilder(movie,index);
            },
          ),
        )
      ])
    );
  }

  Widget _itemBuilder(Player player,index) {
    return Container(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white),
        ),
        Row(
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 5,),
                  Image(image: ExactAssetImage(player.image),width: 120,height: 120,fit:BoxFit.scaleDown),
                  SizedBox(height: 5,),
                  Text(player.name)

              ],)
              ,
              SizedBox(width: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO: just to illustrate in prototype, remove the colors
                  Container(margin: EdgeInsets.all(10), color:(index==0?Colors.yellow:Colors.orange),child:TextButton(child:Text("Matches: "+player.nummatches.toString(),textAlign: TextAlign.left ,),onPressed:()=> {},)),
                  TextButton(child:Text("50s: "+player.num50s.toString(),textAlign: TextAlign.left),onPressed:()=> {},),
                  TextButton(child:Text("100s: "+player.num100s.toString(),textAlign: TextAlign.left),onPressed:()=> {},),
                  TextButton(child:Text("Average: "+player.bataverage.toString(),textAlign: TextAlign.left),onPressed:()=> {},),


                ],)

            ],
          ),

      ]),
    );
  }
}
