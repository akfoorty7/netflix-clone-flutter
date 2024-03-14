import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netflix/widgets/responsive.dart';
import 'package:video_player/video_player.dart';

import '../models/content_model.dart';
import 'Sintel.dart';
import 'VerticalIconButton.dart';

class ContentHeader extends StatelessWidget {
  const ContentHeader({
    Key? key,
    required this.featuredContent
  });
  final Content featuredContent;

  @override
  Widget build(BuildContext context) {
    return  Responsive(mobile: _ContentHeaderMobile(featuredContent: featuredContent),
        desktop: _ContentHeaderDesktop(featuredContent: featuredContent)
    );
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final Content featuredContent;

  const _ContentHeaderMobile({
    super.key,
    required this.featuredContent
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(featuredContent.imageUrl),
              fit: BoxFit.cover,
            ),
          ),

        ),
        Container(
          height: 500.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),

        ),
        Positioned(
          bottom: 110.0,
          child: SizedBox(
            width: 250.0,
            child: Image.asset(featuredContent.titleImageUrl),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: 'List',
                onTap: () => print('My List'),
              ),
              _PlayButton(),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: 'Info',
                onTap: () => print('Info'),
              ),
            ],
          ),

        )
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;

  const _ContentHeaderDesktop({
    super.key,
    required this.featuredContent
  });

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoController;
  bool _ismuted = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoController = VideoPlayerController.network(
        widget.featuredContent.videoUrl)..initialize().then((_) => setState(
            (){}
    ))..setVolume(0)..play();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoController.value.isPlaying ? _videoController.pause() : _videoController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized ? _videoController.value.aspectRatio : 2.344,
            child: _videoController.value.isInitialized ? VideoPlayer(_videoController): Image.asset(widget.featuredContent.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            height: 500.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),

          ),
          Positioned(
            left: 60.0,
            right: 60.0,
            bottom: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250.0,
                  child: Image.asset(widget.featuredContent.titleImageUrl),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(widget.featuredContent.description,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2.0, 4.0),
                          blurRadius: 6.0,
                        )
                      ]
                  ),
                ),
                const SizedBox(height: 20.0,),
                Row(
                  children: [
                    _PlayButton(),
                    const SizedBox(height: 16.0,),
                    TextButton.icon(onPressed: () => print('More'),
                      icon: const Icon(Icons.info_outline, color: Colors.white,),

                      label: const Text('More Info',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,


                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    if (_videoController.value.isInitialized)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(_ismuted ? Icons.volume_off : Icons.volume_up, color: Colors.white,),
                            iconSize: 30.0,
                            onPressed: () => setState(() {
                              _ismuted ? _videoController.setVolume(100) : _videoController.setVolume(0);
                              _ismuted = _videoController.value.volume == 0;
                            }),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class _PlayButton extends StatelessWidget {
  const _PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VideoApp()),
          );
        },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)) ,
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow,
            size: 30.0,
          ),
          const SizedBox(width: 3.0),
          Text(
            'play',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    );
  }
}
