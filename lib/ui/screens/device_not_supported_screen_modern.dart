import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';

class DeviceNotSupportedScreenModern extends StatelessWidget {
  const DeviceNotSupportedScreenModern({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.devices_other_rounded, size: 120, color: colorScheme.onPrimary),
                Spacing.gapVerticalXl,
                Text(
                  'Device Not Supported',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    fontFamily: 'Avenir',
                  ),
                ),
                Spacing.gapVerticalMd,
                Text(
                  'Sorry, this device is not supported by Tooth Tycoon at this time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onPrimary,
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
