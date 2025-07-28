import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/oss_licenses.dart';
import 'package:bread_place/ui/common_widgets/common_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OssLicenseScreen extends StatelessWidget {
  const OssLicenseScreen({super.key});

  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenses = allDependencies.toList();
    for (var key in lm.keys) {
      licenses.add(
        Package(
          name: key,
          description: '',
          authors: [],
          version: '',
          license: lm[key]!.join('\n\n'),
          isMarkdown: false,
          isSdk: false,
          dependencies: [],
        ),
      );
    }
    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: '오픈소스 라이선스',
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: FutureBuilder<List<Package>>(
        future: _licenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('오류가 발생했습니다.'),
            );
          }

          final licenses = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: licenses.length,
            itemBuilder: (context, index) {
              final package = licenses[index];
              return ListTile(
                title: Text('${package.name} ${package.version}'),
                subtitle: package.description.isNotEmpty
                    ? Text(package.description)
                    : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.ossLicenseSingle, extra: package),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;

  const MiscOssLicenseSingle({super.key, required this.package});

  String _bodyText() {
    return package.license!
        .split('\n')
        .map((line) {
          if (line.startsWith('//')) line = line.substring(2);
          line = line.trim();
          return line;
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${package.name} ${package.version}')),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: ListView(
          children: <Widget>[
            if (package.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: Text(
                  package.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            if (package.homepage != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: InkWell(
                  child: Text(
                    package.homepage!,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () => launchUrlString(package.homepage!),
                ),
              ),
            if (package.description.isNotEmpty || package.homepage != null)
              const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 12.0,
                right: 12.0,
              ),
              child: Text(
                _bodyText(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
