import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../service/firebase_signaling.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;

  final signaling = Signaling();
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );
    // _controller.repeat();
    _initCall();
    super.initState();
  }

  _initCall() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    WakelockPlus.enable();

    signaling.onAddRemoteStream = ((stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    });
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
  }

  @override
  void dispose() {
    // _controller.dispose();
    _disposeRenderer();
    super.dispose();
  }

  _disposeRenderer() async {
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var queryParams = GoRouterState.of(context).uri.queryParameters;
    // var roomId = queryParams['roomId'] ?? 'default';
    var roomId = "123";

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: Text(
            roomId,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: CallStreamWidget(
                      renderer: _localRenderer,
                      isMirror: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CallStreamWidget(
                      renderer: _remoteRenderer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: "Start Call",
              onPressed: () async {
                var temp = await signaling.startCall(roomId: roomId);
                setState(() {
                  roomId = temp;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: "Join Call",
              onPressed: () async {
                await signaling.joinCall(roomId);
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: "Hang Up",
              onPressed: () {
                signaling.hangUp(_localRenderer, roomId: roomId).then((value) {
                  context.pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CallStreamWidget extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool isMirror;
  const CallStreamWidget({
    super.key,
    required this.renderer,
    this.isMirror = false,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.4,
      height: 240,
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        // color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black,
        border: Border.all(
          color: Colors.grey.shade500,
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            RTCVideoView(
              renderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: isMirror,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color color;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
