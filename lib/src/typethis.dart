import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:typethis/typethis.dart';

/// {@template typethis}
/// Widget that creates the "typing" animation by making characters
/// in the provided [string] appear one at a time.
///
/// Example:
/// ```dart
/// TypeThis(
///   string: 'Hi there! How are you doing?',
///   speed: 50,
///   style: TextStyle(fontSize: 18, color: Colors.black),
/// );
/// ```
/// {@endtemplate}
class TypeThis extends StatefulWidget {
  /// The text which will be animated.
  final String string;

  /// Speed in milliseconds at which the typing animation will be executed.
  ///
  /// Default value is 50. That means each character in the [string] will render
  /// at a difference of 50 milliseconds.
  final int speed;

  /// Whether to show blinking cursor.
  ///
  /// Default is set to `true`.
  final bool showBlinkingCursor;

  /// The text character shown as the cursor.
  ///
  /// Default is `_` (underscore).
  final String? cursorText;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// [TextStyle] for the [string].
  ///
  /// If non-null, the style to use for this text. Otherwise,
  /// [DefaultTextStyle] will be used.
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double? textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// const Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final ui.TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  ///
  /// This is ignored if [SelectionContainer.maybeOf] returns null
  /// in the [BuildContext] of the [Text] widget.
  ///
  /// If null, the ambient [DefaultSelectionStyle] is used (if any); failing
  /// that, the selection color defaults to [DefaultSelectionStyle.defaultColor]
  /// (semi-transparent grey).
  final Color? selectionColor;

  /// {@macro typethis}
  const TypeThis({
    super.key,
    required this.string,
    this.speed = 50,
    this.showBlinkingCursor = true,
    this.cursorText,
    this.textAlign,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : assert(
          speed >= 0,
          'spped must either be 0 or greater than 0',
        );

  @override
  State<StatefulWidget> createState() => _TypeThisState();
}

class _TypeThisState extends State<TypeThis>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _setAnimationDuration();

    _animation = IntTween(begin: 0, end: widget.string.length)
        .animate(_animationController);

    _animation.addListener(() => setState(() {}));
    _animationController.forward();
  }

  void _setAnimationDuration() {
    final charactersCount = widget.string.length;
    _animationController.duration = Duration(
      milliseconds: charactersCount * widget.speed,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stringToRender = widget.string.substring(0, _animation.value);
    final defaultTextStyle = DefaultTextStyle.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stringToRender,
          key: const Key('typethis_text'),
          textAlign: widget.textAlign ?? defaultTextStyle.textAlign,
          style: defaultTextStyle.style.merge(widget.style),
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap ?? defaultTextStyle.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          semanticsLabel: widget.semanticsLabel,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
          selectionColor: widget.selectionColor,
        ),
        widget.showBlinkingCursor
            ? BlinkingCursor(cursorText: widget.cursorText)
            : const SizedBox.shrink(),
      ],
    );
  }
}
