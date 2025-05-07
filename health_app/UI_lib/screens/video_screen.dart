// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'login_screen.dart';
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key});
//
//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _controller1;
//   late VideoPlayerController _controller2;
//  // late Size videoSize = const Size(1080, 1920); // 宽1080, 高1920
//   bool _isFirstReady = false;
//   bool _isSecondReady = false;
//   bool _showSecond = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // _controller1 = VideoPlayerController.asset('assets/Leaves1.mp4')
//     //   ..initialize().then((_) {
//     //     setState(() {
//     //       _isFirstReady = true;
//     //       _controller1.setLooping(false);
//     //       _controller1.play();
//     //     });
//     //
//     //     _controller1.addListener(_checkFirstVideoEnd);
//     //   });
//
//     _controller2 = VideoPlayerController.asset('assets/Leaves2.mp4')
//       ..initialize().then((_) {
//         setState(() {
//           _isSecondReady = true;
//           _controller2.setLooping(true);
//         });
//       });
//   }
//
//   // void _checkFirstVideoEnd() {
//   //   if (!_showSecond &&
//   //       _controller1.value.position >= _controller1.value.duration &&
//   //       !_controller1.value.isPlaying) {
//   //     setState(() {
//   //       _showSecond = true;
//   //       _controller2.play();
//   //     });
//   //   }
//   //}
//   //
//   // @override
//   // void dispose() {
//   //   _controller1.removeListener(_checkFirstVideoEnd);
//   //   _controller1.dispose();
//   //   _controller2.dispose();
//   //   super.dispose();
//   // }
//
//   void _goToLogin() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: GestureDetector(
//         onTap: _goToLogin,
//         child: Container(
//           width: screenSize.width,
//           height: screenSize.height,
//           color: Colors.black,
//           child: Stack(
//             children: [
//               // 使用Container填满整个屏幕以防视频未加载
//               Container(
//                 width: screenSize.width,
//                 height: screenSize.height,
//                 color: Colors.black,
//               ),
//
//               // 视频播放器 - 使用SizedBox.expand确保视频填充整个屏幕
//               if (_isFirstReady && !_showSecond)
//                 SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _controller1.value.size.width,
//                       height: _controller1.value.size.height,
//                       child: VideoPlayer(_controller1),
//                     ),
//                   ),
//                 )
//               else if (_isSecondReady && _showSecond)
//                 SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _controller2.value.size.width,
//                       height: _controller2.value.size.height,
//                       child: VideoPlayer(_controller2),
//                     ),
//                   ),
//                 )
//               else
//                 const Center(child: CircularProgressIndicator()),
//
//
//
//
//
//
//               // "Tap to continue"按钮 - 保持原有位置
//               Positioned(
//                 top: screenSize.height * 0.8, // 恢复原有位置
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF7D8570).withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: const Offset(3, 2),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     child: const Text(
//                       'Tap to continue',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Quicksand',
//                         fontWeight: FontWeight.w300,
//                         letterSpacing: 0.5,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//
//
//
//
//
//
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
// //chao: 4/18 for this page i stucked for a long time, thus remove the hoom1 and only keep hoom2
// //could iterate in the future
//
// //video charaters layout has been solved 5/1 4:52am

//new error: caused by canva, the letter w shifted a bit to left in first movie
// thus for feasible plan, we can wrap up on 5/7, we can do play second video only
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller2;
  bool _isSecondReady = false;

  @override
  void initState() {
    super.initState();

    _controller2 = VideoPlayerController.asset('assets/Leaves2.mp4')
      ..initialize().then((_) {
        setState(() {
          _isSecondReady = true;
          _controller2.setLooping(true);
          _controller2.play(); // 直接播放
        });
      });
  }

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: _goToLogin,
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black,
          child: Stack(
            children: [
              // 背景填充，防止黑屏闪烁
              Container(
                width: screenSize.width,
                height: screenSize.height,
                color: Colors.black,
              ),

              // 视频播放器
              if (_isSecondReady)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 1080,
                      height: 1920,
                      child: VideoPlayer(_controller2),
                    ),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),

              // "Tap to continue" 按钮
              Positioned(
                top: screenSize.height * 0.8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7D8570).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(3, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: const Text(
                      'Tap to continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
