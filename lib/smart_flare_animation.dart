import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';

enum AnimationPlay {
  Activate,
  Deactivate,
  CameraTapped,
  PulseTapped,
  ImageTapped
}

class SmartFileAnimation extends StatefulWidget {
  SmartFileAnimation({Key? key}) : super(key: key);

  @override
  _SmartFileAnimationState createState() => _SmartFileAnimationState();
}

class _SmartFileAnimationState extends State<SmartFileAnimation> {
  static const double AnimationWidth = 295.0;
  static const double AnimationHeight = 251.0;

  AnimationPlay _animationPlay = AnimationPlay.Deactivate;
  AnimationPlay? _lastPlayedAnimation;
  final FlareControls animationControls = FlareControls();

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AnimationWidth,
        height: AnimationHeight,
        child: GestureDetector(
          onTapUp: (TapUpDetails tapInfo) {
            setState(() {
              Offset localTouchPosition =
                  (context.findRenderObject() as RenderBox)
                      .globalToLocal(tapInfo.globalPosition);

              var topHalfTouched = localTouchPosition.dy < AnimationHeight / 2;
              var leftSideTouched = localTouchPosition.dx < AnimationWidth / 3;
              var rightSideTouched =
                  localTouchPosition.dx > (AnimationWidth / 3) * 2;

              var middleTouched = !leftSideTouched && !rightSideTouched;

              if (leftSideTouched && topHalfTouched)
                _setAnimationPlay(AnimationPlay.CameraTapped);
              else if (middleTouched && topHalfTouched)
                _setAnimationPlay(AnimationPlay.PulseTapped);
              else if (rightSideTouched && topHalfTouched)
                _setAnimationPlay(AnimationPlay.ImageTapped);
              else {
                if (isOpen)
                  _setAnimationPlay(AnimationPlay.Deactivate);
                else
                  _setAnimationPlay(AnimationPlay.Activate);
              }

              isOpen = !isOpen;
            });
          },
          child: FlareActor(
            'assets/button-animation.flr',
            controller: animationControls,
            animation: _getAnimationName(_animationPlay),
          ),
        ));
  }

  String _getAnimationName(AnimationPlay animationPlay) {
    switch (animationPlay) {
      case AnimationPlay.Activate:
        return 'activate';
      case AnimationPlay.CameraTapped:
        return 'camera_tapped';
      case AnimationPlay.PulseTapped:
        return 'pulse_tapped';
      case AnimationPlay.ImageTapped:
        return 'image_tapped';
      default:
        return 'deactivate';
    }
  }

  void _setAnimationPlay(AnimationPlay animation) {
    bool isTappedAnimation = _getAnimationName(animation).contains('_tapped');
    _lastPlayedAnimation = animation;
    if (isTappedAnimation && _lastPlayedAnimation == AnimationPlay.Deactivate) {
      return;
    }

    animationControls.play(_getAnimationName(animation));
  }
}
