import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/wrappers/widgets_binding_wrapper.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ColorTapGame])
@GenerateMocks([ColorTapWorld])
@GenerateMocks([], customMocks: [MockSpec<ComponentsNotifier>()])
@GenerateMocks([FlutterView])
@GenerateMocks([TapDownEvent])
@GenerateMocks([TargetBoard])
@GenerateMocks([TimeManager])
@GenerateMocks([Viewport])
@GenerateMocks([WidgetsBindingWrapper])
main() {}
