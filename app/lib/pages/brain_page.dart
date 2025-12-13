import 'package:flutter/material.dart';
import '../widgets/domain_button.dart';
import 'domains/domain1_page.dart';
import 'domains/domain2_page.dart';
import 'domains/domain3_page.dart';
import 'domains/domain4_page.dart';

class BrainPage extends StatelessWidget {
  const BrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double gridHeight = height * 0.6;
          final double itemHeight = (gridHeight - 16) / 2;
          final double itemWidth = (constraints.maxWidth - 16) / 2;

          final double aspectRatio = itemWidth / itemHeight;

          return Center(
            child: Padding (
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    height: gridHeight,
                    child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                        children: [
                        DomainButton(
                            title: 'Domain 1',
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const Domain1Page(),
                                ),
                            );
                            },
                        ),
                        DomainButton(
                            title: 'Domain 2',
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const Domain2Page(),
                                ),
                            );
                            },
                        ),
                        DomainButton(
                            title: 'Domain 3',
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const Domain3Page(),
                                ),
                            );
                            },
                        ),
                        DomainButton(
                            title: 'Domain 4',
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const Domain4Page(),
                                ),
                            );
                            },
                        ),
                        ],
                    ),
                    ),
            )
          );
        },
      ),
    );
  }
}