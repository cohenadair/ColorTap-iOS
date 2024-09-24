import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/audio_manager.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;
  late MockAudioPool buttonTapPool;
  late MockAudioPool targetCorrectPool;
  late MockAudioPool targetIncorrectPool;
  late MockAudioPool targetSwitchPool;
  late MockAudioPlayer gamePlayer;
  late MockAudioPlayer menuPlayer;

  MockAudioPool stubAudioPool() {
    var result = MockAudioPool();
    when(result.start(volume: anyNamed("volume")))
        .thenAnswer((_) => Future.value(() async {}));
    return result;
  }

  MockAudioPlayer stubAudioPlayer() {
    var result = MockAudioPlayer();
    when(result.pause()).thenAnswer((_) => Future.value());
    when(result.resume()).thenAnswer((_) => Future.value());
    return result;
  }

  setUp(() {
    managers = StubbedManagers();
    buttonTapPool = stubAudioPool();
    targetCorrectPool = stubAudioPool();
    targetIncorrectPool = stubAudioPool();
    targetSwitchPool = stubAudioPool();
    gamePlayer = stubAudioPlayer();
    menuPlayer = stubAudioPlayer();

    when(managers.flameAudioWrapper.loadAll(any))
        .thenAnswer((_) => Future.value([]));

    when(managers.flameAudioWrapper.createPool(
      any,
      maxPlayers: anyNamed("maxPlayers"),
    )).thenAnswer((invocation) {
      var fileName = invocation.positionalArguments.first;
      switch (fileName) {
        case "button-tap.mp3":
          return Future.value(buttonTapPool);
        case "target-correct.mp3":
          return Future.value(targetCorrectPool);
        case "target-incorrect.mp3":
          return Future.value(targetIncorrectPool);
        case "target-switch.mp3":
          return Future.value(targetSwitchPool);
        default:
          fail("Unknown audio pool file name: $fileName");
      }
    });
    when(managers.flameAudioWrapper.loop(
      any,
      volume: anyNamed("volume"),
    )).thenAnswer((invocation) {
      var fileName = invocation.positionalArguments.first;
      switch (fileName) {
        case "bg-game.mp3":
          return Future.value(gamePlayer);
        case "bg-menu.mp3":
          return Future.value(menuPlayer);
        default:
          fail("Unknown audio player file name: $fileName");
      }
    });

    when(managers.fgbgWrapper.stream).thenAnswer((_) => const Stream.empty());

    when(managers.preferenceManager.stream)
        .thenAnswer((_) => const Stream.empty());
    when(managers.preferenceManager.isMusicOn).thenReturn(true);
    when(managers.preferenceManager.isSoundOn).thenReturn(true);

    AudioManager.suicide();
  });

  test("Music is paused when app is backgrounded", () async {
    var controller = StreamController<FGBGType>.broadcast();
    when(managers.fgbgWrapper.stream).thenAnswer((_) => controller.stream);

    await AudioManager.get.init();
    controller.add(FGBGType.background);
    await Future.delayed(const Duration(milliseconds: 50));

    verify(menuPlayer.pause()).called(1);
    verifyNever(menuPlayer.resume());
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("Music is resumed when app is foregrounded", () async {
    var controller = StreamController<FGBGType>.broadcast();
    when(managers.fgbgWrapper.stream).thenAnswer((_) => controller.stream);

    await AudioManager.get.init();
    controller.add(FGBGType.foreground);
    await Future.delayed(const Duration(milliseconds: 50));

    verify(menuPlayer.pause()).called(1);
    verify(menuPlayer.resume()).called(1);
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("Music is paused when turned off in preferences", () async {
    var controller = StreamController.broadcast();
    when(managers.preferenceManager.stream)
        .thenAnswer((_) => controller.stream);
    when(managers.preferenceManager.isMusicOn).thenReturn(true);

    await AudioManager.get.init();
    when(managers.preferenceManager.isMusicOn).thenReturn(false);
    controller.add(null);
    await Future.delayed(const Duration(milliseconds: 50));

    verify(menuPlayer.pause()).called(1);
    verifyNever(menuPlayer.resume());
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("Music is resumed when turned on in preferences", () async {
    var controller = StreamController.broadcast();
    when(managers.preferenceManager.stream)
        .thenAnswer((_) => controller.stream);
    when(managers.preferenceManager.isMusicOn).thenReturn(false);

    await AudioManager.get.init();
    when(managers.preferenceManager.isMusicOn).thenReturn(true);
    controller.add(null);
    await Future.delayed(const Duration(milliseconds: 50));

    verify(menuPlayer.pause()).called(1);
    verify(menuPlayer.resume()).called(1);
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("onButtonPressed plays sound and relays input", () async {
    await AudioManager.get.init();

    var called = false;
    var callback = AudioManager.get.onButtonPressed(() => called = true);
    callback();

    expect(called, true);
    verify(buttonTapPool.start(volume: anyNamed("volume"))).called(1);
  });

  test("resumeMusic in game", () async {
    await AudioManager.get.init();

    await AudioManager.get.playGameBackground();
    verify(menuPlayer.pause()).called(1);
    verifyNever(menuPlayer.resume());
    verify(gamePlayer.resume()).called(1);
    verify(gamePlayer.pause()).called(1);
  });

  test("resumeMusic in menu", () async {
    await AudioManager.get.init();

    await AudioManager.get.playMenuBackground();
    verify(menuPlayer.resume()).called(1);
    verify(menuPlayer.pause()).called(1);
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("pauseMusic pauses both players", () async {
    await AudioManager.get.init();

    await AudioManager.get.pauseMusic();
    verify(menuPlayer.pause()).called(1);
    verifyNever(menuPlayer.resume());
    verify(gamePlayer.pause()).called(1);
    verifyNever(gamePlayer.resume());
  });

  test("Sound not played when turned off", () async {
    when(managers.preferenceManager.isSoundOn).thenReturn(false);

    await AudioManager.get.init();

    var called = false;
    var callback = AudioManager.get.onButtonPressed(() => called = true);
    callback();

    expect(called, true);
    verifyNever(buttonTapPool.start(volume: anyNamed("volume")));
  });

  test("Music not played when turned off", () async {
    when(managers.preferenceManager.isMusicOn).thenReturn(false);

    await AudioManager.get.init();
    await AudioManager.get.playGameBackground();

    verify(menuPlayer.pause()).called(1);
    verifyNever(menuPlayer.resume());
    verifyNever(gamePlayer.resume());
    verify(gamePlayer.pause()).called(1);
  });

  test("Incorrect hit pauses music", () async {
    await AudioManager.get.init();
    await AudioManager.get.playIncorrectHit();

    verify(menuPlayer.pause()).called(1);
    verify(gamePlayer.pause()).called(1);
    verify(targetIncorrectPool.start(volume: anyNamed("volume"))).called(1);
  });

  test("Correct hit plays right sound", () async {
    await AudioManager.get.init();
    await AudioManager.get.playCorrectHit();
    verify(targetCorrectPool.start(volume: anyNamed("volume"))).called(1);
  });

  test("Switch target plays right sound", () async {
    await AudioManager.get.init();
    await AudioManager.get.playSwitchTarget();
    verify(targetSwitchPool.start(volume: anyNamed("volume"))).called(1);
  });
}
