import 'package:flutter/material.dart';
import 'package:infinity_scroll/providers/gif_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late ScrollController _scrollController;
  final List<String> _images = [];
  int offset = 0;
  final int _maxLength = 3175;
  bool isLoading = false;
  bool hasMore = true;

  _getImages() async {
    setState(() {
      isLoading = true;
    });
    final gifList = await GifProvider().getGifs(offset);
    for (var gif in gifList) {
      _images.add(gif.images!.downsized!.url!);
    }

    setState(() {
      isLoading = false;
      offset += 10;
      hasMore = _images.length < _maxLength;
    });
  }

  @override
  void initState() {
    super.initState();
    _getImages();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !isLoading) {
        if (hasMore) {
          _getImages();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Infinite Scroll View'),
      ),
      body: SafeArea(
        child:ListView.separated(
          controller: _scrollController,
          itemCount: _images.length * (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 10,),
          itemBuilder: (context, index){
            if (index == _images.length) {
              return const SizedBox(
                width: 60,
                height: 60,
                child: FittedBox(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                _images[index],
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          },
        )
      ),
    );
  }
}
