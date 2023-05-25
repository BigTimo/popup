library popup;

import 'dart:math';
import 'package:flutter/material.dart';

enum PopPosition {
  top(0),
  bottom(pi),
  left(-pi / 2),
  right(pi / 2),
  ;

  final double angle;

  const PopPosition(this.angle);
}

void showPopup({
  required BuildContext context,
  required Widget child,
  EdgeInsets margin = EdgeInsets.zero,
  PopPosition position = PopPosition.top,
  double arrowSize = 10,
  double arrowAspectRatio = 0.5,
  Color arrowColor = Colors.black,
  bool showArrow = true,
  double space = 0,
  Color? barrierColor,
}) {
  var rendBox = context.findRenderObject() as RenderBox?;
  if (rendBox != null) {
    var size = rendBox.size;
    var offset = rendBox.localToGlobal(Offset.zero);
    var rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    var layout = CustomMultiChildLayout(
      delegate: _MultiChildLayoutDelegate(
        rect: rect,
        position: position,
        margin: margin,
        showArrow: showArrow,
        arrowSize: arrowSize,
        space: space,
      ),
      children: [
        LayoutId(id: _Id.pop, child: Material(child: child)),
        if (showArrow)
          LayoutId(
            id: _Id.arrow,
            child: Transform.rotate(
              angle: position.angle,
              child: Arrow(size: arrowSize, aspectRatio: arrowAspectRatio, color: arrowColor),
            ),
          ),
      ],
    );
    Navigator.push(context, _PopupRoute(child: layout, backColor: barrierColor));
  }
}

enum _Id {
  pop,
  arrow,
}

class _MultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  final Rect rect;
  final PopPosition position;
  final EdgeInsets margin;
  final bool showArrow;
  final double space;
  final double arrowSize;

  _MultiChildLayoutDelegate({
    required this.rect,
    required this.position,
    required this.margin,
    required this.showArrow,
    required this.arrowSize,
    required this.space,
  });

  @override
  void performLayout(Size size) {
    Rect layoutRect = Rect.fromLTRB(margin.left, margin.top, size.width - margin.right, size.height - margin.bottom);
    Rect outRect = getOutRect(layoutRect);
    var popSize = layoutChild(_Id.pop, BoxConstraints.loose(Size(outRect.width, outRect.height)));
    var popRect = getRect(popSize, dis);
    //适配边界
    popRect = keepInside(outRect, popRect);
    //定位pop
    positionChild(_Id.pop, popRect.topLeft);

    if (showArrow) {
      var arrowSize = layoutChild(_Id.arrow, BoxConstraints.loose(Size(outRect.width, outRect.height)));
      var arrowRect = getRect(arrowSize, space);
      positionChild(_Id.arrow, arrowRect.topLeft);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }

  ///点击的widget与pop之间的间距
  double get dis => (showArrow ? arrowSize : 0) + space;

  ///获取目标方块的位置
  Rect getRect(Size size, double space) {
    var dy = (rect.height + size.height) / 2 + space;
    var dx = (rect.width + size.width) / 2 + space;
    Offset offset;
    switch (position) {
      case PopPosition.top:
        offset = Offset(0, -dy);
        break;
      case PopPosition.bottom:
        offset = Offset(0, dy);
        break;
      case PopPosition.left:
        offset = Offset(-dx, 0);
        break;
      case PopPosition.right:
        offset = Offset(dx, 0);
        break;
    }
    Offset center = rect.center.translate(offset.dx, offset.dy);
    return Rect.fromCenter(center: center, width: size.width, height: size.height);
  }

  ///获取pop所在的边界范围
  Rect getOutRect(Rect layoutRect) {
    switch (position) {
      case PopPosition.top:
        return Rect.fromLTRB(layoutRect.left, layoutRect.top, layoutRect.right, rect.top - dis);
      case PopPosition.bottom:
        return Rect.fromLTRB(layoutRect.left, rect.bottom + dis, layoutRect.right, layoutRect.bottom);
      case PopPosition.left:
        return Rect.fromLTRB(layoutRect.left, layoutRect.top, rect.left - dis, layoutRect.bottom);
      case PopPosition.right:
        return Rect.fromLTRB(rect.right + dis, layoutRect.top, layoutRect.right, layoutRect.bottom);
    }
  }

  ///保持b在a范围内
  Rect keepInside(Rect a, Rect b) {
    // 判断 b 是否在 a 范围内
    if (!a.contains(b.topLeft) || !a.contains(b.bottomRight)) {
      // 计算需要移动的距离
      double dx = 0;
      double dy = 0;

      if (b.left < a.left) {
        dx = a.left - b.left;
      } else if (b.right > a.right) {
        dx = a.right - b.right;
      }

      if (b.top < a.top) {
        dy = a.top - b.top;
      } else if (b.bottom > a.bottom) {
        dy = a.bottom - b.bottom;
      }
      return b.shift(Offset(dx, dy));
    } else {
      return b;
    }
  }
}

class _PopupRoute extends PopupRoute {
  final Widget child;
  final Color? backColor;

  _PopupRoute({
    required this.child,
    this.backColor,
  });

  @override
  Color? get barrierColor => backColor;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => const Duration();
}

class _ArrowClipper extends CustomClipper<Path> {
  final double aspectRatio;

  _ArrowClipper(this.aspectRatio);

  @override
  Path getClip(Size size) {
    var width = size.width;
    var arrowHeight = width * aspectRatio;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width / 2, arrowHeight);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Arrow extends StatelessWidget {
  final double size;
  final double aspectRatio;
  final Color color;

  const Arrow({super.key, required this.size, this.aspectRatio = 0.87, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ArrowClipper(aspectRatio),
      child: Container(
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}
