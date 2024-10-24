import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../service/firebase_signaling.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final signaling = Signaling();
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  final textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.repeat();

    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 4.0,
              children: [
                ...List.generate(
                  3,
                  (index) => const CallStreamWidget(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CallStreamWidget extends StatelessWidget {
  const CallStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.4,
      height: 240,
      decoration: BoxDecoration(
        // color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 2.0,
        ),
      ),
      child: RTCVideoView(RTCVideoRenderer()),
    );
  }
}
