#!/usr/bin/env python3
import os
import re

def fix_null_safety_issues(content):
    """Apply common null safety fixes to Dart code."""

    # Fix WillPopScope to PopScope
    content = re.sub(
        r'WillPopScope\(\s*onWillPop:\s*_onBackPress,',
        'PopScope(\n      canPop: false,\n      onPopInvokedWithResult: (didPop, result) {\n        if (!didPop) {\n          _onBackPress();\n        }\n      },',
        content
    )

    # Fix withOpacity to withValues
    content = re.sub(r'\.withOpacity\(([\d.]+)\)', r'.withValues(alpha: \1)', content)

    # Fix CommonResponse null access patterns
    content = re.sub(r'CommonResponse\.pullHistoryData\.(\w+)', r'CommonResponse.pullHistoryData!.\1', content)
    content = re.sub(r'CommonResponse\.pullToothData\.(\w+)', r'CommonResponse.pullToothData!.\1', content)
    content = re.sub(r'CommonResponse\.budget\.symbol', r'CommonResponse.budget?.symbol ?? "\$"', content)
    content = re.sub(r'CommonResponse\.budget\.(\w+)', r'CommonResponse.budget!.\1', content)

    # Fix PreferenceHelper getAccessToken
    content = re.sub(
        r'String token = await PreferenceHelper\(\)\.getAccessToken\(\);',
        r'String? token = await PreferenceHelper().getAccessToken();',
        content
    )

    # Fix _onBackPress return type
    content = re.sub(
        r'Future<bool> _onBackPress\(\) async \{([^}]+)\s+return true;\s*\}',
        r'void _onBackPress() {\1  }',
        content,
        flags=re.DOTALL
    )

    # Fix VideoPlayerController initialization
    content = re.sub(
        r'VideoPlayerController _videoPlayerController;',
        r'late VideoPlayerController _videoPlayerController;',
        content
    )

    # Fix List initialization
    content = re.sub(
        r'List<(\w+)> _(\w+List);',
        r'List<\1>? _\2List;',
        content
    )

    # Fix CameraController
    content = re.sub(
        r'CameraController controller;',
        r'late CameraController controller;',
        content
    )

    # Fix InterstitialAd
    content = re.sub(
        r'InterstitialAd _interstitialAd;',
        r'InterstitialAd? _interstitialAd;',
        content
    )

    # Fix isAlwaysShown in Scrollbar
    content = re.sub(r'isAlwaysShown:\s*\w+,', r'thumbVisibility: true,', content)

    return content

def process_file(filepath):
    """Process a single Dart file."""
    try:
        with open(filepath, 'r') as f:
            content = f.read()

        original = content
        content = fix_null_safety_issues(content)

        if content != original:
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"Fixed: {os.path.basename(filepath)}")
        else:
            print(f"No changes: {os.path.basename(filepath)}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")

# List of files to process
screens_dir = "/Users/lukelanterme/Documents/Code/Personal/Flutter/Projects/ToothTycoon_Flutter/lib/screens"
files_to_fix = [
    "childDetail.dart",
    "congratulationsAfterToothPullScreen.dart",
    "congratulationsScreen.dart",
    "deviceNotSupportedScreen.dart",
    "historyScreen.dart",
    "investScreen.dart",
    "pullToothScreen.dart",
    "questionAnsScreen.dart",
    "receiveBadgeScreen.dart",
    "shareImageScreen.dart",
    "summaryScreen.dart",
    "tellYourFriendScreen.dart"
]

for filename in files_to_fix:
    filepath = os.path.join(screens_dir, filename)
    if os.path.exists(filepath):
        process_file(filepath)