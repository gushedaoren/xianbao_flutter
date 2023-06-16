
import 'dart:convert';

import 'package:beir_flutter/base/BLConfig.dart';
import 'package:beir_flutter/tool/RequestUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:just_audio/just_audio.dart';

class PostDetailPage extends StatefulWidget {
  final dynamic data;
  const PostDetailPage({super.key,required this.data});


  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _player = AudioPlayer();
  var playStatus=1;

  bool _loadImageError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();

  }
  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      var audiourl = getAudioUrl(widget.data);
      if (audiourl != "") {
        final duration = await _player.setUrl( // Load a URL
            audiourl);
        print("mp3 duration:$duration");
        _player.play();
        playStatus=1;
      }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }


  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }



  getTitle(item){
    var title=item["PostTitle"];

    return Text(title,style: TextStyle(fontSize: 18),);

  }

  showImg(item){
    var iconSize=120.0;
    var url=getImgUrl(item);



    return CircleAvatar(
        radius: iconSize+10,
        backgroundColor: Color(0xffFDCF09),
        child: CircleAvatar(
          radius: iconSize,
          backgroundImage: NetworkImage(url),
            onBackgroundImageError: (exception, stackTrace){
              this.setState(() {
                this._loadImageError = true;
              });
            },


            child: this._loadImageError? CircleAvatar(
           radius: iconSize,
          backgroundImage: NetworkImage("https://beir.1kcal.net/wp-content/uploads/2023/03/icon-1024.png"),
        ): null


        )
    );



    // return Container(
    //   width: iconSize,
    //   height: iconSize,
    //   child: Image.network(
    //     url,
    //     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
    //       return Image.asset('assets/images/ic_launcher.png');
    //     },
    //   )
    // );
  }
  getImgUrl(item){
    var PostMetas=item["PostMetas"];
    if(PostMetas!.length>0){
      for(var meta in PostMetas){
        if(meta["MetaKey"]=="org_img_url"){
          var url=meta["MetaValue"];
          url=RequestUtil().replaceImgDomain(url);
          return url;
        }
      }

    }else{
      return "";
    }

  }
  getAudioUrl(item){
    var PostMetas=item["PostMetas"];
    if(PostMetas!.length>0){
      for(var meta in PostMetas){
        if(meta["MetaKey"]=="org_audio_url"){
          var url=meta["MetaValue"];
          print("audiourl:$url");
          return url;
        }
      }

    }else{
      return "";
    }

  }
  showBtn(){
    var btnSize=80.0;
    var imgPath="assets/images/story_play.png";
    if(playStatus==1){
      imgPath="assets/images/story_pause.png";
    }else{
      imgPath="assets/images/story_play.png";
    }
    return GestureDetector(
      onTap: (){
        if(playStatus==1){
          playStatus=0;
          _player.stop();
        }else{
          playStatus=1;
          _player.play();

        }
        setState(() {

        });
      },
      child:  Container(
        width: btnSize,
        height: btnSize,
        child: Image.asset(imgPath),
      )
    );


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.data["PostTitle"]),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
        child:  SingleChildScrollView(
          child:  Container(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              children: [
                showImg(widget.data),

                SizedBox(height: 10,),
                showBtn(),
                SizedBox(height: 10,),
                showContent(widget.data),
                SizedBox(height: 10,),
              ],
            ),

          ),
        )


      )

    );
  }

  showContent(item) {
    var PostContent=widget.data["PostContent"];
    var content="<div style=font-size:18px>"+PostContent+"</div>";
    return Html(
        shrinkWrap: true,
       data:content
    );


  }
}
