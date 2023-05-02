import 'dart:math';
import 'package:cooing_front/model/response/User.dart';
import 'package:flutter/material.dart';

List<String> generateHint(User user) {
  List<String> result = [];
  String name = user.name;

  // 만약 한국어 문자열이 아니라면, []를 반환
  if (!isKorean(name)) {
    return result;
  }

  List hints = [
    // 첫번째 힌트: 이름 초성
    "초성은 '${getConsonants(name)}'",
    // 두번째 힌트: 이름의 첫 글자
    "이름 첫글자는 '${getFirstName(name)}'",
    // 세번째 힌트: 이름 받침 개수
    '이름에 받침이 ${getSumOfConsonants(name)}개',
    // 네번째 힌트: 휴대폰 번호에 가장 많은 숫자
    "휴대폰번호에 가장 많은 숫자는 '${getMostFrequentDigit(user.number)}'",
    // 다섯번째 힌트: 생일 월
    '${getMonthFromBirthday(user.birthday)}월 생일',
    // 여섯번째 힌트: 학년
    '${user.grade}학년',
    // 일곱번째 힌트: 몇~몇반 사이
    '${getClassRange(user.group)}반 사이',
    // 여덟번째 힌트: 무쌍/유쌍
    user.eyes == 0 ? '무쌍' : '유쌍',
    // 아홉번째 힌트: mbti 중 하나
    getMBTI(user.mbti),
    // 열번째 힌트: 취미
    "취미는 '${user.hobby}'",
    // 열한번째 힌트: 스타일
    '${getRandomStyle(user.style)} 스타일'
  ];

  final random = Random();
  List<String> selected = [];

  while (selected.length < 3) {
    final index = random.nextInt(hints.length);
    final hint = hints[index];

    if (!selected.contains(hint)) {
      selected.add(hint);
    }
  }
  result = selected;

  return result;
}

// 한국어 문자열 여부를 반환하는 함수
bool isKorean(String name) {
  // 한글 유니코드 범위: 0xAC00 ~ 0xD7A3
  final koreanRegExp = RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]');

  return koreanRegExp.hasMatch(name);
}

// 자음, 모음이 분리된 리스트를 반환 함수
List<List<String>> separateConsonantsAndVowels(String name) {
  final results = <List<String>>[];

  const base = 0xAC00;

  final firstConsonants = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];
  final secondVowels = [
    'ㅏ',
    'ㅐ',
    'ㅑ',
    'ㅒ',
    'ㅓ',
    'ㅔ',
    'ㅕ',
    'ㅖ',
    'ㅗ',
    'ㅘ',
    'ㅙ',
    'ㅚ',
    'ㅛ',
    'ㅜ',
    'ㅝ',
    'ㅞ',
    'ㅟ',
    'ㅠ',
    'ㅡ',
    'ㅢ',
    'ㅣ'
  ];
  final thirdConsonants = [
    '',
    'ㄱ',
    'ㄲ',
    'ㄳ',
    'ㄴ',
    'ㄵ',
    'ㄶ',
    'ㄷ',
    'ㄹ',
    'ㄺ',
    'ㄻ',
    'ㄼ',
    'ㄽ',
    'ㄾ',
    'ㄿ',
    'ㅀ',
    'ㅁ',
    'ㅂ',
    'ㅄ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];

  final nameChars = name.characters.toList();
  for (final char in nameChars) {
    final diff = char.codeUnitAt(0) - base;
    final first = ((diff / 28) / 21).floor();
    final middle = ((diff / 28) % 21).floor();
    final finalChar = (diff % 28).floor();
    results.add([
      firstConsonants[first],
      secondVowels[middle],
      thirdConsonants[finalChar],
    ]);
  }
  return results;
}

// 첫번째 힌트: 이름 초성을 반환하는 함수
String getConsonants(String name) {
  String result = '';

  final separatedName = separateConsonantsAndVowels(name);
  for (var i in separatedName) {
    result += i[0];
  }

  return result;
}

// 두번째 힌트: 이름의 첫 글자를 반환하는 함수
String getFirstName(String name) {
  String result = name[0];

  return result;
}

// 세번째 힌트: 이름 받침 개수를 반환하는 함수
int getSumOfConsonants(String name) {
  int result = 0;

  final separatedName = separateConsonantsAndVowels(name);
  for (var i in separatedName) {
    if (i[2].isNotEmpty) {
      result += 1;
    }
  }

  return result;
}

// 네번째 힌트: 휴대폰 번호에 가장 많은 숫자를 반환하는 함수
int getMostFrequentDigit(String phoneNumber) {
  int result = 0;

  final digitsRegExp = RegExp(r'\d');
  final digits = phoneNumber
      .replaceAll('010', '')
      .split('')
      .where((digit) => digitsRegExp.hasMatch(digit));

  if (digits.isEmpty) {
    return result;
  }

  final digitCounts = <int, int>{};

  for (var digit in digits) {
    final intDigit = int.parse(digit);
    digitCounts[intDigit] = (digitCounts[intDigit] ?? 0) + 1;
  }

  result = digitCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  return result;
}

// 다섯번째 힌트: 생일 월을 반환하는 함수
String getMonthFromBirthday(String birthday) {
  String? result = '';

  final dateRegExp = RegExp(r'^\d{4}-(\d{2})-\d{2}$');
  final match = dateRegExp.firstMatch(birthday);

  if (match == null) {
    return result;
  }

  final month = match.group(1);
  result = month!.startsWith('0') ? month.substring(1) : month;
  return result;
}

// 일곱번째 힌트: 몇~몇반 사이를 반환하는 함수
String getClassRange(int number) {
  String result = '';

  if (number <= 0) {
    return result;
  }

  final lowerBound = (number - 1) ~/ 5 * 5 + 1;
  final upperBound = lowerBound + 4;

  result = '$lowerBound~$upperBound';
  return result;
}

// 아홉번째 힌트: mbti 중 하나를 반환하는 함수
String getMBTI(String mbti) {
  String result = '';

  final random = Random();
  final randomIndex = random.nextInt(mbti.length);
  final selectedOption = mbti[randomIndex];

  switch (randomIndex) {
    case 0:
      result = "첫번째 MBTI는 '$selectedOption'";
      break;
    case 1:
      result = "두번째 MBTI는 '$selectedOption'";
      break;
    case 2:
      result = "세번째 MBTI는 '$selectedOption'";
      break;
    case 3:
      result = "네번째 MBTI는 '$selectedOption'";
      break;
    default:
      result = '';
  }

  return result;
}

// 열한번째 힌트: 스타일을 랜덤으로 반환하는 함수
String getRandomStyle(List styles) {
  String result = '';

  final random = Random();
  final index = random.nextInt(styles.length);

  result = styles[index];
  return result;
}
