import 'package:fluent_ui/fluent_ui.dart';

class DownloadEventDialog extends StatelessWidget {
  /// Creates a content dialog.
  const DownloadEventDialog({
    super.key,
    this.actions,
    this.style,
    this.constraints = kDefaultContentDialogConstraints,
  });

  /// The actions of the dialog. Usually, a List of [Button]s
  final List<Widget>? actions;
  /// The style used by this dialog. If non-null, it's merged with
  /// [FluentThemeData.dialogTheme]
  final ContentDialogThemeData? style;

  /// The constraints of the dialog. It defaults to `BoxConstraints(maxWidth: 368)`
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final style = ContentDialogThemeData.standard(FluentTheme.of(
      context,
    )).merge(FluentTheme.of(context).dialogTheme.merge(this.style));

    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        constraints: constraints,
        decoration: style.decoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: style.padding ?? EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text('添加链接'),
                      TextBox(
                        maxLines: null,
                        placeholder: 'lianjie',
                        expands: false,
                      ),
                  ],
                ),
              ),
            ),
              Container(
                decoration: style.actionsDecoration,
                padding: style.actionsPadding,
                child: ButtonTheme.merge(
                  data: style.actionThemeData ?? const ButtonThemeData(),
                  child: () {
                    if (actions!.length == 1) {
                      return Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: actions!.first,
                      );
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!.map((e) {
                        final index = actions!.indexOf(e);
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: index != (actions!.length - 1)
                                  ? style.actionsSpacing ?? 3
                                  : 0,
                            ),
                            child: e,
                          ),
                        );
                      }).toList(),
                    );
                  }(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}