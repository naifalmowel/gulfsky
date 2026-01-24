import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollProvider extends ChangeNotifier {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int _currentSectionIndex = 0;
  bool _isScrolling = false;
  bool _showNavbar = true; // Always show navbar as requested
  bool _isInitialized = false;
  bool _isAtTop = true;



  int get currentSectionIndex => _currentSectionIndex;
  bool get isScrolling => _isScrolling;
  bool get showNavbar => _showNavbar;
  bool get isInitialized => _isInitialized;
  bool get isAtTop => _isAtTop;
init(){
  itemScrollController = ItemScrollController();
  itemPositionsListener = ItemPositionsListener.create();
}
  ScrollProvider() {
    // Listen to scroll position changes with error handling
    itemPositionsListener.itemPositions.addListener(_onPositionChanged);

    // Mark as initialized after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _isInitialized = true;
      notifyListeners();
    });
  }

  void _onPositionChanged() {
    try {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty && _isInitialized) {
        // Find the section that is most visible
        ItemPosition? mostVisible;
        double maxVisibility = 0.0;

        for (final position in positions) {
          double visibility = 0.0;

          if (position.itemLeadingEdge >= 0 && position.itemTrailingEdge <= 1) {
            // Fully visible
            visibility = 1.0;
          } else if (position.itemLeadingEdge < 0 && position.itemTrailingEdge > 0) {
            // Partially visible from top
            visibility = position.itemTrailingEdge;
          } else if (position.itemLeadingEdge < 1 && position.itemTrailingEdge > 1) {
            // Partially visible from bottom
            visibility = 1.0 - position.itemLeadingEdge;
          }

          if (visibility > maxVisibility) {
            maxVisibility = visibility;
            mostVisible = position;
          }
        }
        final atTop = positions.any((p) => p.index == 0 && p.itemLeadingEdge >= 0.0);

        if (_isAtTop != atTop) {
          _isAtTop = atTop;
          notifyListeners();
        }
        if (mostVisible != null && _currentSectionIndex != mostVisible.index) {
          _currentSectionIndex = mostVisible.index;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Position listener error: $e');
    }
  }

  Future<void> scrollToSection(int sectionIndex) async {
    if (_isScrolling || !_isInitialized) return;

    // Validate section index
    if (sectionIndex < 0 || sectionIndex > 5) return;

    _isScrolling = true;
    notifyListeners();

    try {
      if (itemScrollController.isAttached) {
        await itemScrollController.scrollTo(
          index: sectionIndex,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutCubic,
          alignment: 0.0, // Align to top
        );
      }

    } catch (e) {
      debugPrint('Scroll error: $e');
    } finally {
      // Add delay to ensure scroll completes
      await Future.delayed(const Duration(milliseconds: 100));
      _isScrolling = false;
      notifyListeners();
    }
  }

  Future<void> scrollToTop() async {
    await scrollToSection(0);
  }

  Future<void> scrollToAbout() async {
    await scrollToSection(1);
  }

  Future<void> scrollToServices() async {
    await scrollToSection(2);
  }

  Future<void> scrollToProjects() async {
    await scrollToSection(3);
  }

  Future<void> scrollToContact() async {
    await scrollToSection(4);
  }

  Future<void> scrollToFooter() async {
    await scrollToSection(5);
  }

  // Method to check if controller is ready
  bool get isControllerReady {
    return _isInitialized && itemScrollController.isAttached;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
