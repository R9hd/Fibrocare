import 'package:fibercare/homepage.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'language_manager.dart';

class PhysicalActivityPage extends StatefulWidget {
  const PhysicalActivityPage({super.key});

  @override
  State<PhysicalActivityPage> createState() => _PhysicalActivityPageState();
}

class _PhysicalActivityPageState extends State<PhysicalActivityPage> {
  String? _selectedBodyPart;
  final Map<String, List<String>> _exercises = {
    'head': [
      languageManager.translate('neckRotations'),
      languageManager.translate('chinTucks'),
      languageManager.translate('sideNeckStretches'),
    ],
    'shoulder_left': [
      languageManager.translate('leftArmCircles'),
      languageManager.translate('leftShoulderRolls'),
      languageManager.translate('leftArmStretch'),
    ],
    'shoulder_right': [
      languageManager.translate('rightArmCircles'),
      languageManager.translate('rightShoulderRolls'),
      languageManager.translate('rightArmStretch'),
    ],
    'chest': [
      languageManager.translate('chestStretch'),
      languageManager.translate('pushups'),
      languageManager.translate('pecStretch'),
    ],
    'abdomen': [
      languageManager.translate('pelvicTilts'),
      languageManager.translate('forwardBend'),
      languageManager.translate('deepBreathing'),
    ],
    'legs': [
      languageManager.translate('squats'),
      languageManager.translate('hamstringStretch'),
      languageManager.translate('calfRaises'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color tertiary = Theme.of(context).colorScheme.tertiary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(languageManager.translate('physicalActivity'),
            style: TextStyle(color: tertiary)),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFd4e8eb),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBodyDiagram(),
                  if (_selectedBodyPart != null) _buildExercisesList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyDiagram() {
    return GestureDetector(
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) return;

        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final size = renderBox.size;
        final centerX = size.width / 2;

        if (localPosition.dy < 220) {
          if (localPosition.dx > centerX - 40 && localPosition.dx < centerX + 40) {
            setState(() => _selectedBodyPart = 'head');
            return;
          }
        }
        if (localPosition.dy >= 230 && localPosition.dy < 290) {
          if (localPosition.dx > centerX - 50 && localPosition.dx < centerX + 50) {
            setState(() => _selectedBodyPart = 'chest');
            return;
          }
        }
        if (localPosition.dy >= 200 && localPosition.dy < 350) {
          if (localPosition.dx < centerX - 50) {
            setState(() => _selectedBodyPart = 'shoulder_left');
          } else if (localPosition.dx > centerX + 50) {
            setState(() => _selectedBodyPart = 'shoulder_right');
          }
          return;
        }
        if (localPosition.dy >= 300 && localPosition.dy < 400) {
          if (localPosition.dx > centerX - 40 && localPosition.dx < centerX + 40) {
            setState(() => _selectedBodyPart = 'abdomen');
            return;
          }
        }
        if (localPosition.dy >= 400 && localPosition.dy < 500) {
          setState(() => _selectedBodyPart = 'legs');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 500),
          painter: BodyPainter(selectedPart: _selectedBodyPart),
        ),
      ),
    );
  }

  Widget _buildExercisesList() {
    final exercises = _exercises[_selectedBodyPart] ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageManager.translate('exercisesFor', params: {
              'bodyPart': languageManager.translate(_selectedBodyPart!)
            }),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ...exercises.map((exercise) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(child: Text(exercise)),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }
}

class BodyPainter extends CustomPainter {
  final String? selectedPart;

  BodyPainter({this.selectedPart});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final headColor = selectedPart == 'head' ? highlightPaint : paint;
    canvas.drawCircle(Offset(size.width / 2, 50), 40, headColor);

    final torsoColor = selectedPart == 'chest' || selectedPart == 'abdomen'
        ? highlightPaint
        : paint;
    final path = Path()
      ..moveTo(size.width / 2 - 50, 90)
      ..lineTo(size.width / 2 - 30, 290)
      ..lineTo(size.width / 2 + 30, 290)
      ..lineTo(size.width / 2 + 50, 90)
      ..close();
    canvas.drawPath(path, torsoColor);

    final leftArmColor = selectedPart == 'shoulder_left' ? highlightPaint : paint;
    final rightArmColor = selectedPart == 'shoulder_right' ? highlightPaint : paint;
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2 - 70, 90, 20, 150), leftArmColor);
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2 + 50, 90, 20, 150), rightArmColor);

    final legsColor = selectedPart == 'legs' ? highlightPaint : paint;
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2 - 30, 290, 20, 150), legsColor);
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2 + 10, 290, 20, 150), legsColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}