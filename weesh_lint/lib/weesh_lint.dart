import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _WeeshLintPlugin();

class _WeeshLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const NoGenericAppBarRule(),
        const NoGenericCardRule(),
        const NoMuddyColorRule(),
      ];
}

class NoGenericAppBarRule extends DartLintRule {
  const NoGenericAppBarRule() : super(code: _code);

  static const _code = LintCode(
    name: 'weesh_no_generic_appbar',
    problemMessage: 'Use WeeshAppBar instead of the generic AppBar to enforce design guidelines.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final name = node.constructorName.type.name2.lexeme;
      if (name == 'AppBar') {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}

class NoGenericCardRule extends DartLintRule {
  const NoGenericCardRule() : super(code: _code);

  static const _code = LintCode(
    name: 'weesh_no_generic_card',
    problemMessage: 'Use WeeshCard instead of the generic Card to enforce design guidelines.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final name = node.constructorName.type.name2.lexeme;
      if (name == 'Card') {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}

class NoMuddyColorRule extends DartLintRule {
  const NoMuddyColorRule() : super(code: _code);

  static const _code = LintCode(
    name: 'weesh_no_muddy_color',
    problemMessage: 'Avoid using the old beige color (0xFFF3EFEA). Follow the new Hyper-Clean Minimalist design system.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final name = node.constructorName.type.name2.lexeme;
      if (name == 'Color') {
        final arguments = node.argumentList.arguments;
        if (arguments.isNotEmpty) {
          final colorVal = arguments.first.beginToken.lexeme;
          if (colorVal.toLowerCase().contains('0xfff3efea')) {
            reporter.reportErrorForNode(code, node);
          }
        }
      }
    });
  }
}
