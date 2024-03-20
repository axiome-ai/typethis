import 'dart:async';
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

  /// To fill the needed space right from the start of the animation and avoid avoid
  /// shifting of surrounding elements during animation
  ///
  /// You should avoid using this feature a lot, as it requires more resources
  /// due to the Stack widget
  ///
  /// Default is set to `false`.
  final bool fillSpaceFromStart;

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

  /// Deprecated. Will be removed in a future version of Flutter. Use
  /// [textScaler] instead.
  ///
  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  @Deprecated(
    'Use textScaler instead. '
    'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
    'This feature was deprecated after v3.12.0-2.0.pre.',
  )
  final double? textScaleFactor;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

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

  /// A controller for a [TypeThis] widget.
  ///
  /// Exposes three main methods for controlling the typing animation.
  ///
  /// `reset` method resets the typing animation and restarts it from beginning.
  ///
  /// `freeze` method freezes or pauses the typing animation.
  ///
  /// `unfreeze` method resumes the typing anmation from where it was frozen last time.
  ///
  /// Remember to [dispose] of the [TypeThisController] when it is no longer
  /// needed. This will ensure we discard any resources used by the object.
  final TypeThisController? controller;

  /// List of [TypeThisMatcher].
  ///
  /// The string will be matched with the provided [TypeThisMatcher]s' regex patterns.
  /// And text style will be added to the matched strings.
  final List<TypeThisMatcher> richTextMatchers;

  /// {@macro typethis}
  const TypeThis({
    super.key,
    required this.string,
    this.speed = 50,
    this.showBlinkingCursor = true,
    this.fillSpaceFromStart = false,
    this.controller,
    this.cursorText,
    this.textAlign,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    @Deprecated(
      'Use textScaler instead. '
      'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
      'This feature was deprecated after v3.12.0-2.0.pre.',
    )
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.richTextMatchers = const <TypeThisMatcher>[],
  })  : assert(
          speed >= 0,
          'spped must either be 0 or greater than 0',
        ),
        assert(
          textScaler == null || textScaleFactor == null,
          'textScaleFactor is deprecated and cannot be specified when textScaler is specified.',
        );

  @override
  State<TypeThis> createState() => _TypeThisState();
}

class _TypeThisState extends State<TypeThis> {
  List<Map<String, TextStyle?>> richTextMappers = [];
  int currentStep = 0;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    final matchers = widget.richTextMatchers;

    final patternsList = matchers.map((matcher) => matcher.regexPattern);
    final pattern = patternsList.isNotEmpty ? patternsList.join('|') : '(?!.*)';

    widget.string.splitMapJoin(
      RegExp(pattern),
      onMatch: (Match match) {
        final matchData = match[0];
        final matcherToConsider = matchers.firstWhere(
          (matcher) => RegExp(matcher.regexPattern).hasMatch(matchData ?? ''),
        );

        if (matchData != null) {
          richTextMappers.add(<String, TextStyle?>{
            matchData: matcherToConsider.style ?? widget.style,
          });
        }

        return '';
      },
      onNonMatch: (String nonMatch) {
        richTextMappers.add(<String, TextStyle?>{
          nonMatch: widget.style,
        });
        return '';
      },
    );

    _startTimerAndUpdateState();
    widget.controller?.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.controller?.state == TypeThisControllerState.start) {
      timer.cancel();
      currentStep = 0;
      _startTimerAndUpdateState();
    } else if (widget.controller?.state == TypeThisControllerState.frozen) {
      timer.cancel();
    } else if (widget.controller?.state == TypeThisControllerState.resumed) {
      timer.cancel();
      if (currentStep != widget.string.length) {
        _startTimerAndUpdateState();
      }
    }
  }

  void _startTimerAndUpdateState() {
    timer = Timer.periodic(Duration(milliseconds: widget.speed), (_) {
      currentStep++;
      if (currentStep == widget.string.length) {
        timer.cancel();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    // ignore: deprecated_member_use_from_same_package
    final textScaleFactor = widget.textScaleFactor;
    final textScaler = widget.textScaler ??
        (textScaleFactor != null ? TextScaler.linear(textScaleFactor) : null);

    List<TextSpan> widgets = <TextSpan>[];

    int renderedTextLength = 0;
    for (int i = 0; i < richTextMappers.length; i++) {
      final currentTextMapperEntry = richTextMappers[i].entries.first;
      final currentTextMapperContentLength = currentTextMapperEntry.key.length;

      if (renderedTextLength + currentTextMapperContentLength <= currentStep) {
        widgets.add(
          TextSpan(
            text: currentTextMapperEntry.key,
            style: currentTextMapperEntry.value,
          ),
        );
        renderedTextLength += currentTextMapperEntry.key.length;
      } else {
        int extraSpace = currentStep - renderedTextLength;

        final nextCharacterToShow = currentTextMapperEntry.key
            .substring(extraSpace, extraSpace + 1);
        if (nextCharacterToShow == ' ') {
          setState(() {
            currentStep++;
          });
        }

        final writingSequenceText =
            currentTextMapperEntry.key.substring(0, extraSpace);

        widgets.add(
          TextSpan(
            text: writingSequenceText,
            style: currentTextMapperEntry.value,
          ),
        );
        renderedTextLength += writingSequenceText.length;
        break;
      }
    }

    final richTextAnimatedWidget = Text.rich(
      TextSpan(children: [...widgets]),
      textAlign: widget.textAlign ?? defaultTextStyle.textAlign,
      style: defaultTextStyle.style.merge(widget.style),
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap ?? defaultTextStyle.softWrap,
      overflow: widget.overflow,
      textScaler: textScaler,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );

    final richTextWidget = Text.rich(
      TextSpan(text: widget.string),
      textAlign: widget.textAlign ?? defaultTextStyle.textAlign,
      style: defaultTextStyle.style.merge(widget.style),
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap ?? defaultTextStyle.softWrap,
      overflow: widget.overflow,
      textScaler: textScaler,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );

    final textAndCursorRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: richTextAnimatedWidget),
        widget.showBlinkingCursor
            ? BlinkingCursor(cursorText: widget.cursorText)
            : const SizedBox.shrink(),
      ],
    );

    return widget.fillSpaceFromStart
        ? Stack(
            children: [
              Opacity(opacity: 0, child: richTextWidget),
              textAndCursorRow
            ],
          )
        : textAndCursorRow;
  }
}
