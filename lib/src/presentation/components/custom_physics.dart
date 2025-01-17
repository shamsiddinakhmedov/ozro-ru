import 'package:flutter/cupertino.dart';

ScrollPhysics getBouncingAlwaysScrollPhysics() => const AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    );
