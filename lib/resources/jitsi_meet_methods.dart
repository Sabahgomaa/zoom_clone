import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import 'auth_methods.dart';
import 'firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FireStoreMethods _fireStoreMethods = FireStoreMethods();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      Map<FeatureFlag, Object> featureFlags = {
        FeatureFlag.isWelcomePageEnabled: false,
      };
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }
      var options = JitsiMeetingOptions(
          roomNameOrUrl: roomName,
          userDisplayName: name,
          userEmail: _authMethods.user.email,
          isAudioMuted: isAudioMuted,
          userAvatarUrl: _authMethods.user.photoURL,
          isVideoMuted: isVideoMuted);

      _fireStoreMethods.addToMeetingHistory(roomName);
      await JitsiMeetWrapper.joinMeeting(
        options: options,
      );
    } catch (error) {
      if (kDebugMode) {
        print("error: $error");
      }
    }
  }
}
