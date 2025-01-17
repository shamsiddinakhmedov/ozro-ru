// import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:ozro_mobile/src/core/extension/extension.dart';
//
// class BetterPlayerWidget extends StatefulWidget {
//   const BetterPlayerWidget({
//     super.key,
//     required this.videoLink,
//   });
//
//   final String videoLink;
//
//   @override
//   State<BetterPlayerWidget> createState() => _BetterPlayerWithNetworkUrlWidgetState();
// }
//
// class _BetterPlayerWithNetworkUrlWidgetState extends State<BetterPlayerWidget> {
//
//   late BetterPlayerController _betterPlayerController;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   void _initializePlayer() {
//     final BetterPlayerConfiguration betterPlayerConfiguration =
//     BetterPlayerConfiguration(
//       aspectRatio: 16 / 16,
//       fit: BoxFit.cover,
//       controlsConfiguration: BetterPlayerControlsConfiguration(
//         loadingColor: context.color.midGrey4,
//         enablePip: false,
//         enableProgressText: false,
//         enableMute: false,
//         enableOverflowMenu: false,
//         enableSkips: false,
//         enableFullscreen: false,
//         enableProgressBar: false,
//         enablePlayPause: false,
//         controlBarColor: Colors.black12.withOpacity(0.3),
//         playerTheme: BetterPlayerTheme.material,
//       )
//     );
//
//     final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       widget.videoLink,
//     );
//
//
//     _betterPlayerController = BetterPlayerController(
//       betterPlayerConfiguration,
//       betterPlayerDataSource: dataSource,
//     );
//   }
//
//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) => Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       height: 200, // Video hajmini sozlash
//       child: BetterPlayer(
//         controller: _betterPlayerController,
//       ),
//     );
// }
