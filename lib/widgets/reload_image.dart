import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReloadableImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color color;

  const ReloadableImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    required this.color,
  });

  @override
  State<ReloadableImage> createState() => _ReloadableImageState();
}

class _ReloadableImageState extends State<ReloadableImage> {
  late String _url;

  @override
  void initState() {
    super.initState();
    _url = widget.imageUrl;
  }

  @override
  void didUpdateWidget(ReloadableImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تغيّر الـ imageUrl، نقوم بتحديث الـ url لكسر الـ cache
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _url = widget.imageUrl;
      });
    }
  }

  void _reloadImage() {
    setState(() {
      // نضيف قيمة زمنية بسيطة لكسر الكاش
      _url = "${widget.imageUrl}?v=${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: widget.color,
        ),
      ),
      errorWidget: (context, url, error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                onPressed: _reloadImage,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      fadeInDuration: const Duration(milliseconds: 400),
    );
  }
}
