import 'dart:io';

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class Utils {
  Widget buildLoadingWidget() {
    return const Center(
        child: SizedBox(
      height: 30,
      width: 30,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Color(0xFFBBCC6E),
        ),
      ),
    ));
  }

  onBackPress(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Desea salir de la aplicación?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                TextButton(onPressed: () => exit(0), child: const Text('Si'))
              ],
            ));
    return false;
  }

  Widget emptyComponent(String msg) {
    return Center(
        child: Text(
      msg,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ));
  }

  Widget emptyComponentWithLotie(String msg, String urlLottie) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200, width: 200, child: Lottie.asset(urlLottie)),
        Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    ));
  }

  Widget buildLoadingWidgetWithText(String msg) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Color(0xFF02204c),
          ),
        )
      ],
    ));
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget buildPoint() {
    return Container(
      height: 5,
      width: 5,
      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    );
  }

  bool getCheckStatus(List<Map> snapshot) {
    bool isCheckProblem = false;
    for (int i = 0; i < snapshot.length; i++) {
      if (snapshot[i]['status'] == true) {
        isCheckProblem = true;
        break;
      } else {
        isCheckProblem = false;
      }
    }
    return isCheckProblem;
  }

  int calculateAge(String date) {
    int years = 0;
    DateTime birthDate = DateTime.parse(date);
    DateTime current = DateTime.now();
    years = current.year - birthDate.year;
    if (birthDate.month > current.month) {
      return years - 1;
    } else {
      return years;
    }
  }

  bool validCedula(String input) {
    input = input.replaceAll(' ', '');
    if (input.length <= 1) {
      return false;
    }
    if (int.tryParse(input) == null) {
      return false;
    }
    List<String> list = input.split('');
    list = list.reversed.toList();
    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      int element = int.parse(list[i]);
      if (i.isOdd) {
        int doubledElement = element * 2 > 9 ? element * 2 - 9 : element * 2;
        sum += doubledElement;
      } else {
        sum += element;
      }
    }
    return sum % 10 == 0;
  }
}

extension GroupBy<T> on Iterable<T> {
  Map<E, List<T>> groupBy<E>(E Function(T) groupFunction) => fold(
      <E, List<T>>{},
      (Map<E, List<T>> initialMap, T element) =>
          initialMap..putIfAbsent(groupFunction(element), () => <T>[]).add(element));
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PassportValidator on String {
  bool isValidPassport() {
    return RegExp(r'^[A-Z]+[0-9]+$').hasMatch(this);
  }
}
