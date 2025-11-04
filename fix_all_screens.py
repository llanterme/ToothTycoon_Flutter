#!/usr/bin/env python3
import os
import re

def fix_file(filepath):
    """Fix a single file with comprehensive patterns."""
    with open(filepath, 'r') as f:
        content = f.read()

    original = content

    # Fix CommonResponse null safety
    content = re.sub(r'CommonResponse\.pullHistoryData\.(\w+)',
                    r'CommonResponse.pullHistoryData!.\1', content)
    content = re.sub(r'CommonResponse\.pullToothData\.(\w+)',
                    r'CommonResponse.pullToothData!.\1', content)
    content = re.sub(r'CommonResponse\.pullToothData!\.earn!',
                    r'CommonResponse.pullToothData!.earn', content)
    content = re.sub(r'CommonResponse\.budget\.symbol',
                    r"CommonResponse.budget?.symbol ?? '\$'", content)
    content = re.sub(r'CommonResponse\.budget\.(\w+)',
                    r'CommonResponse.budget!.\1', content)
    content = re.sub(r"CommonResponse\.budget\?\.symbol \?\? '\$'!",
                    r"CommonResponse.budget?.symbol ?? '\$'", content)

    # Fix childDetail specific issues
    if 'childDetail.dart' in filepath:
        content = re.sub(r'CommonResponse\.childModelResponse\.name',
                        r'CommonResponse.childModelResponse!.name', content)
        content = re.sub(r'CommonResponse\.childModelResponse\.age',
                        r'CommonResponse.childModelResponse!.age', content)
        content = re.sub(r'CommonResponse\.childModelResponse\.img',
                        r'CommonResponse.childModelResponse!.img', content)
        content = re.sub(r'backgroundImage: image,',
                        r'backgroundImage: image as ImageProvider<Object>,', content)
        content = re.sub(r'routeName: Constants.KEY_ROUTE_CAPTURE_IMAGE, arguments: null',
                        r"routeName: Constants.KEY_ROUTE_CAPTURE_IMAGE, arguments: ''", content)
        # Fix missing return statement
        if 'Widget _buildTeethView(' in content:
            content = re.sub(r'(Widget _buildTeethView\([^)]*\) \{[^}]*)\}',
                            lambda m: m.group(1) + '\n    return Container(); // Add default return\n  }'
                            if 'return' not in m.group(1) else m.group(0),
                            content)

    # Fix congratulationsScreen
    if 'congratulationsScreen.dart' in filepath:
        content = re.sub(r'CommonResponse\.questionAnswerResponse\.count',
                        r'CommonResponse.questionAnswerResponse!.count', content)

    # Fix historyScreen
    if 'historyScreen.dart' in filepath:
        # Fix _teethList declaration
        content = re.sub(r'List<TeethList>\? _teethList;',
                        r'List<TeethList>? _teethsList;', content)
        content = re.sub(r'_teethList =',
                        r'_teethsList =', content)
        content = re.sub(r'_teethList\.',
                        r'_teethsList?.', content)
        content = re.sub(r'_teethList\[',
                        r'_teethsList![', content)
        content = re.sub(r'_teethList !=',
                        r'_teethsList !=', content)
        content = re.sub(r'CommonResponse\.pullHistoryData!\.teethList!\.isNotEmpty',
                        r'CommonResponse.pullHistoryData!.teethList?.isNotEmpty ?? false', content)
        content = re.sub(r'_teethsList = CommonResponse\.pullHistoryData!\.teethList',
                        r'_teethsList = CommonResponse.pullHistoryData!.teethList', content)

    # Fix pullToothScreen
    if 'pullToothScreen.dart' in filepath:
        content = re.sub(r"arguments: null",
                        r"arguments: ''", content)

    # Fix questionAnsScreen
    if 'questionAnsScreen.dart' in filepath:
        content = re.sub(r'CommonResponse\.questionAnswerResponse\.count',
                        r'CommonResponse.questionAnswerResponse!.count', content)

    # Fix summaryScreen
    if 'summaryScreen.dart' in filepath:
        content = re.sub(r'CommonResponse\.pullHistoryData!\.teethList!\.isNotEmpty',
                        r'(CommonResponse.pullHistoryData!.teethList?.isNotEmpty ?? false)', content)
        content = re.sub(r'CommonResponse\.pullHistoryData!\.teethList!\.length',
                        r'(CommonResponse.pullHistoryData!.teethList?.length ?? 0)', content)
        content = re.sub(r'CommonResponse\.pullHistoryData!\.teethList',
                        r'CommonResponse.pullHistoryData!.teethList', content)

    # Fix PreferenceHelper
    content = re.sub(r'String token = await PreferenceHelper\(\)\.getAccessToken\(\);',
                    r'String? token = await PreferenceHelper().getAccessToken();', content)

    # Fix withOpacity
    content = re.sub(r'\.withOpacity\(([\d.]+)\)', r'.withValues(alpha: \1)', content)

    # Fix WillPopScope to PopScope
    content = re.sub(r'WillPopScope\(\s*onWillPop: _onBackPress,',
                    r'PopScope(\n      canPop: false,\n      onPopInvokedWithResult: (didPop, result) {\n        if (!didPop) {\n          _onBackPress();\n        }\n      },', content)

    # Fix _onBackPress return type
    content = re.sub(r'Future<bool> _onBackPress\(\) async \{([^}]+)\s+return true;\s*\}',
                    r'void _onBackPress() {\1  }',
                    content, flags=re.DOTALL)

    # Fix VideoPlayerController
    content = re.sub(r'VideoPlayerController _videoPlayerController;',
                    r'late VideoPlayerController _videoPlayerController;', content)

    # Fix isAlwaysShown in Scrollbar
    content = re.sub(r'isAlwaysShown:\s*\w+,', r'thumbVisibility: true,', content)

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Fixed: {os.path.basename(filepath)}")
        return True
    return False

# Process all screen files
screens_dir = "/Users/lukelanterme/Documents/Code/Personal/Flutter/Projects/ToothTycoon_Flutter/lib/screens"
bottomsheet_dir = "/Users/lukelanterme/Documents/Code/Personal/Flutter/Projects/ToothTycoon_Flutter/lib/bottomsheet"

# Fix screens
for filename in os.listdir(screens_dir):
    if filename.endswith('.dart'):
        filepath = os.path.join(screens_dir, filename)
        fix_file(filepath)

# Fix signupBottomSheet
signup_path = os.path.join(bottomsheet_dir, 'signupBottomSheet.dart')
if os.path.exists(signup_path):
    with open(signup_path, 'r') as f:
        content = f.read()

    # Fix the specific line 466 issue
    content = re.sub(r'String token = await PreferenceHelper\(\)\.getAccessToken\(\);',
                    r'String? token = await PreferenceHelper().getAccessToken();', content)

    with open(signup_path, 'w') as f:
        f.write(content)
    print("Fixed: signupBottomSheet.dart")

print("\nAll fixes applied!")