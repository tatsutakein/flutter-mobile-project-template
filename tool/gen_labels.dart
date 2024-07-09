// ignore_for_file: unreachable_from_main
import 'dart:io';
import 'dart:math';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'utils/constants.dart';
import 'utils/melos.dart';
import 'utils/path.dart';

void runGeneratePackageLabels() {
  final rootDir = fetchGitRootDirPath();
  log('rootDir: $rootDir');

  final labelsFile = File(join(rootDir, '.github', 'labels.yml'));
  if (!labelsFile.existsSync()) {
    fail('Required files not found.');
  }

  final melosPackageList = fetchMelosPackageList();

  // 自動生成の区切り行を探す
  final labelsContentLines = labelsFile.readAsLinesSync();
  final autoGeneratedIndex = labelsContentLines.indexWhere(
    (line) => line.contains(autoGeneratedLabelComment),
  );
  if (autoGeneratedIndex == -1) {
    fail('Auto-generated label section not found.');
  }

  // 自動生成より前のテキストのみ取得する
  final preGeneratedContent = labelsContentLines
      .sublist(
        0,
        autoGeneratedIndex,
      )
      .join('\n');
  // 自動生成以降のテキストを取得する
  final generatedContent = labelsContentLines.sublist(autoGeneratedIndex);

  final labelsYaml = loadYaml(generatedContent.join('\n')) as YamlList;
  final generatedLabels = <Map<String, String>>[];
  for (final package in melosPackageList) {
    final name = package.location.replaceAll('$rootDir/', '');
    final labelName = '@$name';
    final existingLabel = labelsYaml.firstWhere(
      (label) => (label as YamlMap)['name'] == labelName,
      orElse: () => null,
    );

    final existingDescription = existingLabel?['description'];
    final existingFromName = existingLabel?['from_name'];
    final newLabel = <String, String>{
      'name': labelName,
      'color': existingLabel?['color'].toString() ?? _generateRandomColor(),
      'description': existingDescription?.toString() ??
          '${name.replaceAll('/', ' ')} package',
      if (existingFromName != null) 'from_name': existingFromName!.toString(),
    };

    generatedLabels.add(newLabel);
  }

  // auto-generated部分に新しいラベルを追加
  final generatedLineList =
      (YamlEditor('')..update([], generatedLabels)).toString().split('\n');
  final modifiedLines = <String>[];
  for (final line in generatedLineList) {
    if (line.startsWith('-') && modifiedLines.isNotEmpty) {
      modifiedLines.add('');
    }
    modifiedLines.add(line.replaceAll(r'\/', '/'));
  }

  final postGeneratedContent = modifiedLines.join('\n');

  // コメント行を保持しつつ新しいYAML内容に置き換える
  final updatedContent = [
    preGeneratedContent,
    autoGeneratedLabelComment,
    postGeneratedContent,
    // NOTE: 末尾に改行を追加するために空文字を追加
    '',
  ].join('\n');

  labelsFile.writeAsStringSync(updatedContent);
  log('Labels updated successfully.');
}

String _generateRandomColor() {
  // ランダムなRGB値を生成
  final random = Random();
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);

  // RGB値を16進数に変換してカラーコードを生成
  final colorCode = r.toRadixString(16).padLeft(2, '0') +
      g.toRadixString(16).padLeft(2, '0') +
      b.toRadixString(16).padLeft(2, '0');

  return colorCode;
}
