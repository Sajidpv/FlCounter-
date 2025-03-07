import 'package:counter/model/user_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserSettings settings;
  bool isResizing = false;

  @override
  void initState() {
    super.initState();
    final userSettingsBox = Hive.box<UserSettings>('userSettingsBox');
    settings = userSettingsBox.get('globalSettings') ?? UserSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tap Settings")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Enable Full-Screen Tap"),
            value: settings.isFullScreenTap,
            onChanged: (value) {
              setState(() {
                settings.isFullScreenTap = value;
                settings.save();
              });
            },
          ),
          if (!settings.isFullScreenTap)
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: settings.tapAreaX,
                    top: settings.tapAreaY,
                    width: settings.tapWidth,
                    height: settings.tapHeight,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        if (!isResizing) {
                          setState(() {
                            settings.tapAreaX += details.delta.dx;
                            settings.tapAreaY += details.delta.dy;
                            settings.save();
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onPanStart: (_) =>
                                    setState(() => isResizing = true),
                                onPanUpdate: (details) {
                                  setState(() {
                                    settings.tapWidth =
                                        (settings.tapWidth + details.delta.dx)
                                            .clamp(50, 300);
                                    settings.tapHeight =
                                        (settings.tapHeight + details.delta.dy)
                                            .clamp(50, 300);
                                    settings.save();
                                  });
                                },
                                onPanEnd: (_) =>
                                    setState(() => isResizing = false),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
