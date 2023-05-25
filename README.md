## Features

一个弹窗组件，使用`PopupRoute`弹出。

<img src="https://s2.loli.net/2023/05/25/YML6AKSti5Dnepm.jpg" alt="QQ图片20230525141242.jpg" style="zoom: 25%;" />

## Getting started

Import `package:popup/popup.dart`

使用Builder包裹点击的Widget，调用showPopup方法即可

| 属性名           | 类型         | 默认值          | 简介                                 |
| ---------------- | ------------ | --------------- | ------------------------------------ |
| context          | BuildContext | 必填            | 为了方便获取点击的widget的尺寸和位置 |
| child            | Widget       | 必填            | 弹出的widget                         |
| margin           | EdgeInsets   | EdgeInsets.zero | 弹窗边距                             |
| position         | PopPosition  | PopPosition.top | 弹出的位置                           |
| arrowSize        | double       | 10              | 箭头的尺寸                           |
| arrowAspectRatio | double       | 0.5             | 箭头高宽比                           |
| arrowColor       | Color        | Colors.black    | 箭头颜色                             |
| showArrow        | bool         | true            | 是否显示箭头                         |
| space            | double       | 0               | 点击的widget与弹窗箭头之间的间距     |
| barrierColor     | Color        | null            | 弹窗背景颜色                         |

## Usage

```dart
Builder _buildChild(PopPosition position) {
    var name = position.name.split(".").first;
    return Builder(builder: (context) {
      return GestureDetector(
        onLongPress: () {
          showPopup(
              position: position,
              context: context,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  List.generate(Random().nextInt(10) + 3, (index) => name).toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ));
        },
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          width: 100,
          height: 100,
          child: Center(
            child: Text(name),
          ),
        ),
      );
    });
  }
```

