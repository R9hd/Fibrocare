import 'package:fibercare/community.dart';
import 'package:fibercare/loginpage.dart';
import 'package:fibercare/physicalactivitypage.dart';
import 'package:fibercare/sleepschedual.dart';
import 'package:fibercare/userprofile.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:provider/provider.dart';
import 'language_manager.dart';
import 'language_switch.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color tertiary = Theme.of(context).colorScheme.tertiary;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageManager.translate('home'),
            style: TextStyle(color: tertiary)),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: tertiary),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
          },
        ),
        actions: [
          // THE NEXT METHOD WAS FOR TESTING
          // const LanguageSwitch(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Userprofile()),
              );
            },
            icon: Icon(Icons.account_circle_outlined, color: secondary, size: 35),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFd4e8eb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            SizedBox(height: screenHeight * 0.560),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SleepSchedulePage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.025,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.025,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: tertiary),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.timer, color: primaryColor, size: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.3000,
                                ),
                                child: Text(
                                  languageManager.translate('sleepSchedule'),
                                  style: TextStyle(
                                    color: secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.40),
                SizedBox(height: screenHeight * 0.460),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Community()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.025,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.025,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: tertiary),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.people_alt_sharp, color: primaryColor, size: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.2900,
                                ),
                                child: Text(
                                  languageManager.translate('supportCommunity'),
                                  style: TextStyle(
                                    color: secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.745),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhysicalActivityPage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.025,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.025,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: tertiary),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.boy_sharp, color: primaryColor, size: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.2800,
                                ),
                                child: Text(
                                  languageManager.translate('physicalActivity'),
                                  style: TextStyle(
                                    color: secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: screenHeight * 1.030),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(languageManager.translate('comingSoon'))),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: screenHeight * 0.025,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenHeight * 0.025,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: tertiary),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.medical_information_sharp, color: primaryColor, size: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.2900,
                            ),
                            child: Text(
                              languageManager.translate('foodAssistant'),
                              style: TextStyle(
                                color: secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}