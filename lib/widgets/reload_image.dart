import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReloadableImage extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final bool useAspectRatio;
  final double aspectRatio;

  const ReloadableImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.useAspectRatio = true,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<ReloadableImage> createState() => _ReloadableImageState();
}

class _ReloadableImageState extends State<ReloadableImage> {
  bool _hasError = false;
  String? _processedUrl;
  int _retryCount = 0;
  final int _maxRetries = 5;

  @override
  void initState() {
    super.initState();
    _processUrl();
  }

  void _processUrl() {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      try {
        // تشفير الرابط للتعامل مع المسافات والرموز الخاصة
        _processedUrl = Uri.encodeFull(widget.imageUrl!.trim());
      } catch (e) {
        _processedUrl = widget.imageUrl;
      }
    }
  }

  @override
  void didUpdateWidget(ReloadableImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _hasError = false;
        _retryCount = 0;
        _processUrl();
      });
    }
  }

  void _retryLoading() {
    if (_retryCount < _maxRetries) {
      setState(() {
        _hasError = false;
        _retryCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.color ?? Theme.of(context).primaryColor;
    // إذا كانت الصورة فارغة أو حدث خطأ، نعرض عنصر بحجم محدد
    if (_processedUrl == null || _processedUrl!.isEmpty || _hasError) {
      return SizedBox(
        width: widget.width ?? 300,
        height: widget.height ?? 200,
        child: _buildErrorWidget(themeColor),
      );
    }

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        _processedUrl!,
        key: ValueKey("$_processedUrl-$_retryCount"),
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: const Color.fromARGB(255, 245, 245, 245)!,
            child: Container(color: Colors.white),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // محاولة إعادة التحميل تلقائياً إذا لم نتجاوز الحد الأقصى
          if (_retryCount < _maxRetries) {
            Future.microtask(() {
              if (mounted && !_hasError) {
                // _retryLoading();
              }
            });
            return Container(); // نعود بـ Container فارغ أثناء إعادة المحاولة
          }

          // إذا فشلت جميع المحاولات، نعرض واجهة الخطأ
          Future.microtask(() {
            if (mounted && !_hasError) {
              setState(() {
                _hasError = true;
              });
            }
          });
          return Container(); // نعود بـ Container فارغ لتجنب تداخل العناصر
        },
      ),
    );

    // إذا تم تعطيل aspectRatio، نعرض الصورة بحجمها الطبيعي
    if (!widget.useAspectRatio) {
      return imageWidget;
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: imageWidget,
    );
  }

  Widget _buildErrorWidget(Color color) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 30),
          const SizedBox(height: 4),
          Text(
            "Failed to load image",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _retryLoading,
            child: Text(
              "Retry ($_retryCount/$_maxRetries)",
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
