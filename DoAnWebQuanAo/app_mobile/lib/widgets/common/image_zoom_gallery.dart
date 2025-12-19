import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Image Zoom Gallery - Xem ảnh zoom với swipe
class ImageZoomGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? title;

  const ImageZoomGallery({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.title,
  });

  /// Show as full screen
  static Future<void> show(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
    String? title,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ImageZoomGallery(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          title: title,
        ),
      ),
    );
  }

  @override
  State<ImageZoomGallery> createState() => _ImageZoomGalleryState();
}

class _ImageZoomGalleryState extends State<ImageZoomGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title ?? 'Ảnh ${_currentIndex + 1}/${widget.imageUrls.length}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Gallery
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: PhotoViewHeroAttributes(tag: 'image_$index'),
              );
            },
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null 
                    ? null 
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          
          // Thumbnails
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildThumbnails(),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnails() {
    return SizedBox(
      height: 60,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            final isSelected = index == _currentIndex;
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[800]),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Simple Image Preview - Xem ảnh đơn giản
class ImagePreview extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const ImagePreview({
    super.key,
    required this.imageUrl,
    this.heroTag,
  });

  static Future<void> show(BuildContext context, String imageUrl, {String? heroTag}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ImagePreview(imageUrl: imageUrl, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: heroTag != null
            ? Hero(
                tag: heroTag!,
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                ),
              )
            : PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
      ),
    );
  }
}
