/*
 * Copyright (c) 2019 gomgom. https://www.gomgom.net
 *
 * Source code has been modified by FlutterFlow, Inc. and the below license 
 * applies only to this file. Adapted from "language_picker" pub.dev package.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';

class FlutterFlowLanguageSelector extends StatelessWidget {
  const FlutterFlowLanguageSelector({
    Key? key,
    required this.currentLanguage,
    required this.languages,
    required this.onChanged,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor = const Color(0xFF262D34),
    this.borderRadius = 8.0,
    this.textStyle,
    this.hideFlags = false,
    this.flagSize = 24.0,
    this.flagTextGap = 8.0,
    this.dropdownColor,
    this.dropdownIconColor = const Color(0xFF14181B),
    this.dropdownIcon,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String currentLanguage;
  final List<String> languages;
  final Function(String) onChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool hideFlags;
  final double flagSize;
  final double? flagTextGap;
  final Color? dropdownColor;
  final Color? dropdownIconColor;
  final IconData? dropdownIcon;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        child: _LanguagePickerDropdown(
          currentLanguage: currentLanguage,
          languages: _languageMap(languages.toSet()),
          onChanged: onChanged,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          dropdownColor: dropdownColor,
          dropdownIconColor: dropdownIconColor,
          dropdownIcon: dropdownIcon,
          itemBuilder: (language) => _LanguagePickerItem(
            language: language.isoCode,
            languages: languages,
            textStyle: textStyle,
            hideFlags: hideFlags,
            flagSize: flagSize,
            flagTextGap: flagTextGap,
          ),
        ),
      );
}

class _LanguagePickerItem extends StatelessWidget {
  const _LanguagePickerItem({
    Key? key,
    required this.language,
    required this.languages,
    this.textStyle,
    this.hideFlags = false,
    this.flagSize = 24.0,
    this.flagTextGap = 8.0,
  }) : super(key: key);

  final String language;
  final List<String> languages;
  final TextStyle? textStyle;
  final bool hideFlags;
  final double flagSize;
  final double? flagTextGap;

  @override
  Widget build(BuildContext context) {
    final flagInfo = languageToCountryInfo[language];
    Widget flagWidget = Container();
    if (flagInfo is String) {
      final flagEmoji = EmojiConverter.fromAlpha2CountryCode(flagInfo);
      flagWidget = Text(
        flagEmoji,
        style: const TextStyle(
          fontSize: 20.0,
          height: 1.5,
        ),
      );
    } else if (flagInfo is Map) {
      final flagUrl = flagInfo['flag'] as String;
      flagWidget = Image.network(
        flagUrl,
        width: 24,
        height: 20,
      );
    }
    flagWidget = Transform.scale(
      scale: flagSize / 24.0,
      child: Container(
        width: 24,
        child: flagWidget,
      ),
    );
    return Row(
      children: [
        if (!hideFlags) ...[
          flagWidget,
          SizedBox(width: flagTextGap),
        ],
        Text(
          _languageMap(languages.toSet())[language]?.name ?? '',
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
        ),
      ],
    );
  }
}

/// Provides a customizable [DropdownButton] for all languages
class _LanguagePickerDropdown extends StatelessWidget {
  const _LanguagePickerDropdown({
    required this.itemBuilder,
    required this.currentLanguage,
    required this.onChanged,
    required this.languages,
    this.backgroundColor,
    this.borderColor = const Color(0xFF262D34),
    this.borderRadius = 8.0,
    this.dropdownColor,
    this.dropdownIconColor = const Color(0xFF14181B),
    this.dropdownIcon,
  });

  /// This function will be called to build the child of DropdownMenuItem.
  final Widget Function(Language) itemBuilder;

  /// The current ISO ALPHA-2 code.
  final String currentLanguage;

  /// This function will be called whenever a Language item is selected.
  final ValueChanged<String> onChanged;

  /// List of languages available in this picker.
  final Map<String, Language> languages;

  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final Color? dropdownColor;
  final Color? dropdownIconColor;
  final IconData? dropdownIcon;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = languages.values
        .map(
          (language) => DropdownMenuItem<String>(
            value: language.isoCode,
            child: itemBuilder(language),
          ),
        )
        .toList();
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: DropdownButton<String>(
            isExpanded: true,
            underline: Container(),
            dropdownColor: dropdownColor ?? backgroundColor,
            focusColor: Colors.transparent,
            iconEnabledColor: dropdownIconColor,
            iconDisabledColor: dropdownIconColor,
            icon: dropdownIcon != null
                ? Icon(
                    dropdownIcon,
                    size: 18.0,
                    color: dropdownIconColor,
                  )
                : null,
            hint: const Text(
              'Unset',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Product Sans',
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
            onChanged: (val) {
              if (val != null) {
                onChanged(val);
              }
            },
            items: items,
            value: currentLanguage.isNotEmpty ? currentLanguage : null,
          ),
        ),
      ),
    );
  }
}

class Language {
  Language(this.isoCode, this.name);

  Language.fromMap(Map<String, String> map)
      : name = map['name']!,
        isoCode = map['isoCode']!;

  final String name;
  final String isoCode;
}

Map<String, Language> _languageMap(Set<String> languages) => Map.fromEntries(
      _defaultLanguagesList
          .where((element) => languages.contains(element['isoCode']))
          .map((e) => MapEntry(e['isoCode']!, Language.fromMap(e))),
    );

final List<Map<String, String>> _defaultLanguagesList = [
  {"isoCode": "aa", "name": "Afaraf"},
  {"isoCode": "af", "name": "Afrikaans"},
  {"isoCode": "ak", "name": "Akan"},
  {"isoCode": "sq", "name": "Shqip"},
  {"isoCode": "am", "name": "አማርኛ"},
  {"isoCode": "ar", "name": "العربية"},
  {"isoCode": "hy", "name": "Հայերեն"},
  {"isoCode": "as", "name": "অসমীয়া"},
  {"isoCode": "ay", "name": "aymar"},
  {"isoCode": "az", "name": "azərbaycan"},
  {"isoCode": "bm", "name": "bamanankan"},
  {"isoCode": "ba", "name": "башҡорт теле"},
  {"isoCode": "eu", "name": "euskara, euskera"},
  {"isoCode": "be", "name": "беларуская мова"},
  {"isoCode": "bn", "name": "বাংলা"},
  {"isoCode": "bh", "name": "भोजपुरी"},
  {"isoCode": "bi", "name": "Bislama"},
  {"isoCode": "nb", "name": "Norsk bokmål"},
  {"isoCode": "bs", "name": "bosanski jezik"},
  {"isoCode": "br", "name": "brezhoneg"},
  {"isoCode": "bg", "name": "български език"},
  {"isoCode": "my", "name": "ဗမာစာ"},
  {"isoCode": "ca", "name": "català"},
  {"isoCode": "km", "name": "ភាសាខ្មែរ"},
  {"isoCode": "ch", "name": "Chamoru"},
  {"isoCode": "ce", "name": "нохчийн мотт"},
  {"isoCode": "ny", "name": "chiCheŵa"},
  {"isoCode": "zh_Hans", "name": "中文 (简体)"},
  {"isoCode": "zh_Hant", "name": "中文 (繁體)"},
  {"isoCode": "cv", "name": "чӑваш чӗлхи"},
  {"isoCode": "cr", "name": "ᓀᐦᐃᔭᐍᐏᐣ"},
  {"isoCode": "hr", "name": "hrvatski jezik"},
  {"isoCode": "cs", "name": "čeština"},
  {"isoCode": "da", "name": "dansk"},
  {"isoCode": "dv", "name": "ދިވެހި"},
  {"isoCode": "nl", "name": "Nederlands"},
  {"isoCode": "dz", "name": "རྫོང་ཁ"},
  {"isoCode": "en", "name": "English"},
  {"isoCode": "eo", "name": "Esperanto"},
  {"isoCode": "et", "name": "eesti"},
  {"isoCode": "ee", "name": "Eʋegbe"},
  {"isoCode": "fo", "name": "føroyskt"},
  {"isoCode": "fj", "name": "vosa Vakaviti"},
  {"isoCode": "fi", "name": "suomi"},
  {"isoCode": "fr", "name": "français"},
  {"isoCode": "ff", "name": "Fulfulde"},
  {"isoCode": "gd", "name": "Gàidhlig"},
  {"isoCode": "gl", "name": "galego"},
  {"isoCode": "lg", "name": "Luganda"},
  {"isoCode": "ka", "name": "ქართული"},
  {"isoCode": "de", "name": "Deutsch"},
  {"isoCode": "el", "name": "ελληνικά"},
  {"isoCode": "gn", "name": "Avañe'ẽ"},
  {"isoCode": "gu", "name": "ગુજરાતી"},
  {"isoCode": "ht", "name": "Kreyòl ayisyen"},
  {"isoCode": "ha", "name": "هَوُسَ"},
  {"isoCode": "he", "name": "עברית"},
  {"isoCode": "hz", "name": "Otjiherero"},
  {"isoCode": "hi", "name": "हिन्दी, हिंदी"},
  {"isoCode": "ho", "name": "Hiri Motu"},
  {"isoCode": "hu", "name": "magyar"},
  {"isoCode": "is", "name": "Íslenska"},
  {"isoCode": "io", "name": "Ido"},
  {"isoCode": "ig", "name": "Asụsụ Igbo"},
  {"isoCode": "id", "name": "Bahasa Indonesia"},
  {"isoCode": "ia", "name": "Interlingua"},
  {"isoCode": "ie", "name": "Interlingue"},
  {"isoCode": "iu", "name": "ᐃᓄᒃᑎᑐᑦ"},
  {"isoCode": "ik", "name": "Iñupiaq"},
  {"isoCode": "ga", "name": "Gaeilge"},
  {"isoCode": "it", "name": "Italiano"},
  {"isoCode": "ja", "name": "日本語 (にほんご)"},
  {"isoCode": "jv", "name": "ꦧꦱꦗꦮ"},
  {"isoCode": "kl", "name": "kalaallisut"},
  {"isoCode": "kn", "name": "ಕನ್ನಡ"},
  {"isoCode": "kr", "name": "Kanuri"},
  {"isoCode": "ks", "name": "कश्मीरी"},
  {"isoCode": "kk", "name": "қазақ тілі"},
  {"isoCode": "ki", "name": "Gĩkũyũ"},
  {"isoCode": "rw", "name": "Ikinyarwanda"},
  {"isoCode": "ky", "name": "Кыргызча"},
  {"isoCode": "kv", "name": "коми кыв"},
  {"isoCode": "kg", "name": "Kikongo"},
  {"isoCode": "ko", "name": "한국어"},
  {"isoCode": "kj", "name": "Kuanyama"},
  {"isoCode": "ku", "name": "Kurdî"},
  {"isoCode": "lo", "name": "ພາສາລາວ"},
  {"isoCode": "la", "name": "latine"},
  {"isoCode": "lv", "name": "latviešu valoda"},
  {"isoCode": "li", "name": "Limburgs"},
  {"isoCode": "ln", "name": "Lingála"},
  {"isoCode": "lt", "name": "lietuvių kalba"},
  {"isoCode": "lu", "name": "Tshiluba"},
  {"isoCode": "lb", "name": "Lëtzebuergesch"},
  {"isoCode": "mk", "name": "македонски јазик"},
  {"isoCode": "mg", "name": "fiteny malagasy"},
  {"isoCode": "ms", "name": "bahasa Melayu"},
  {"isoCode": "ml", "name": "മലയാളം"},
  {"isoCode": "mt", "name": "Malti"},
  {"isoCode": "gv", "name": "Gaelg, Gailck"},
  {"isoCode": "mi", "name": "te reo Māori"},
  {"isoCode": "mr", "name": "मराठी"},
  {"isoCode": "mh", "name": "Kajin M̧ajeļ"},
  {"isoCode": "mn", "name": "Монгол хэл"},
  {"isoCode": "na", "name": "Dorerin Naoero"},
  {"isoCode": "nv", "name": "Diné bizaad"},
  {"isoCode": "nd", "name": "Ndebele (Southern)"},
  {"isoCode": "nr", "name": "Ndebele (Northern)"},
  {"isoCode": "ng", "name": "Owambo"},
  {"isoCode": "ne", "name": "नेपाली"},
  {"isoCode": "se", "name": "Davvisámegiella"},
  {"isoCode": "no", "name": "Norsk"},
  {"isoCode": "nn", "name": "Norsk nynorsk"},
  {"isoCode": "oc", "name": "occitan"},
  {"isoCode": "oj", "name": "ᐊᓂᔑᓈᐯᒧᐎᓐ"},
  {"isoCode": "or", "name": "ଓଡ଼ିଆ"},
  {"isoCode": "om", "name": "Afaan Oromoo"},
  {"isoCode": "os", "name": "ирон æвзаг"},
  {"isoCode": "pi", "name": "पाऴि"},
  {"isoCode": "pa", "name": "ਪੰਜਾਬੀ"},
  {"isoCode": "fa", "name": "فارسی"},
  {"isoCode": "pl", "name": "polszczyzna"},
  {"isoCode": "pt", "name": "Português"},
  {"isoCode": "ps", "name": "پښتو"},
  {"isoCode": "qu", "name": "Runa Simi, Kichwa"},
  {"isoCode": "ro", "name": "Română"},
  {"isoCode": "rm", "name": "rumantsch grischun"},
  {"isoCode": "rn", "name": "Ikirundi"},
  {"isoCode": "ru", "name": "Русский"},
  {"isoCode": "sm", "name": "gagana fa'a Samoa"},
  {"isoCode": "sg", "name": "yângâ tî sängö"},
  {"isoCode": "sa", "name": "संस्कृतम्"},
  {"isoCode": "sc", "name": "sardu"},
  {"isoCode": "sr", "name": "српски језик"},
  {"isoCode": "sn", "name": "chiShona"},
  {"isoCode": "ii", "name": "ꆈꌠ꒿ Nuosuhxop"},
  {"isoCode": "sd", "name": "सिन्धी"},
  {"isoCode": "si", "name": "සිංහල"},
  {"isoCode": "sk", "name": "slovenský jazyk"},
  {"isoCode": "sl", "name": "slovenščina"},
  {"isoCode": "so", "name": "Soomaaliga"},
  {"isoCode": "st", "name": "Sesotho"},
  {"isoCode": "es", "name": "Español"},
  {"isoCode": "su", "name": "Basa Sunda"},
  {"isoCode": "sw", "name": "Kiswahili"},
  {"isoCode": "ss", "name": "SiSwati"},
  {"isoCode": "sv", "name": "svenska"},
  {"isoCode": "tl", "name": "Tagalog"},
  {"isoCode": "ty", "name": "Reo Tahiti"},
  {"isoCode": "tg", "name": "тоҷикӣ"},
  {"isoCode": "ta", "name": "தமிழ்"},
  {"isoCode": "tt", "name": "татар теле"},
  {"isoCode": "te", "name": "తెలుగు"},
  {"isoCode": "th", "name": "ไทย"},
  {"isoCode": "bo", "name": "བོད་ཡིག"},
  {"isoCode": "ti", "name": "ትግርኛ"},
  {"isoCode": "to", "name": "faka Tonga"},
  {"isoCode": "ts", "name": "Xitsonga"},
  {"isoCode": "tn", "name": "Setswana"},
  {"isoCode": "tr", "name": "Türkçe"},
  {"isoCode": "tk", "name": "Түркмен"},
  {"isoCode": "tw", "name": "Twi"},
  {"isoCode": "ug", "name": "ئۇيغۇرچە"},
  {"isoCode": "uk", "name": "Українська"},
  {"isoCode": "ur", "name": "اردو"},
  {"isoCode": "uz", "name": "Oʻzbek"},
  {"isoCode": "ve", "name": "Tshivenḓa"},
  {"isoCode": "vi", "name": "Tiếng Việt"},
  {"isoCode": "vo", "name": "Volapük"},
  {"isoCode": "wa", "name": "walon"},
  {"isoCode": "cy", "name": "Cymraeg"},
  {"isoCode": "fy", "name": "Frysk"},
  {"isoCode": "wo", "name": "Wollof"},
  {"isoCode": "xh", "name": "Xhosa"},
  {"isoCode": "yi", "name": "ייִדיש"},
  {"isoCode": "yo", "name": "Yorùbá"},
  {"isoCode": "za", "name": "Saɯ cueŋƅ"},
  {"isoCode": "zu", "name": "Zulu"},
];

final Map<String, dynamic> languageToCountryInfo = {
  "aa": "dj",
  "af": "za",
  "ak": "gh",
  "sq": "al",
  "am": "et",
  "ar": {
    "proposed_iso_3166": "aa",
    "flag":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Flag_of_the_Arab_League.svg/400px-Flag_of_the_Arab_League.svg.png",
    "name": "Arab League"
  },
  "hy": "am",
  "ay": {
    "proposed_iso_3166": "wh",
    "flag":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Banner_of_the_Qulla_Suyu.svg/1920px-Banner_of_the_Qulla_Suyu.svg.png",
    "name": "Wiphala"
  },
  "az": "az",
  "bm": "ml",
  "be": "by",
  "bn": "bd",
  "bi": "vu",
  "bs": "ba",
  "bg": "bg",
  "my": "mm",
  "ca": "ad",
  "zh": "cn",
  "hr": "hr",
  "cs": "cz",
  "da": "dk",
  "dv": "mv",
  "nl": "nl",
  "dz": "bt",
  "en": "gb",
  "et": "ee",
  "ee": {
    "proposed_iso_3166": "ew",
    "flag":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Flag_of_the_Ewe_people.svg/2880px-Flag_of_the_Ewe_people.svg.png",
    "name": "Ewe"
  },
  "fj": "fj",
  "fil": "ph",
  "fi": "fi",
  "fr": "fr",
  "gaa": "gh",
  "ka": "ge",
  "de": "de",
  "el": "gr",
  "gu": "in",
  "ht": "ht",
  "he": "il",
  "hi": "in",
  "ho": "pg",
  "hu": "hu",
  "is": "is",
  "ig": "ng",
  "id": "id",
  "ga": "ie",
  "it": "it",
  "ja": "jp",
  "kr": "ne",
  "kk": "kz",
  "km": "kh",
  "kmb": "ao",
  "rw": "rw",
  "kg": "cg",
  "ko": "kr",
  "kj": "ao",
  "ku": "iq",
  "ky": "kg",
  "lo": "la",
  "la": "va",
  "lv": "lv",
  "ln": "cg",
  "lt": "lt",
  "lu": "cd",
  "lb": "lu",
  "mk": "mk",
  "mg": "mg",
  "ms": "my",
  "mt": "mt",
  "mi": "nz",
  "mh": "mh",
  "mn": "mn",
  "mos": "bf",
  "ne": "np",
  "nd": "zw",
  "nso": "za",
  "no": "no",
  "nb": "no",
  "nn": "no",
  "ny": "mw",
  "pap": "aw",
  "ps": "af",
  "fa": "ir",
  "pl": "pl",
  "pt": "pt",
  "pa": "in",
  "qu": "wh",
  "ro": "ro",
  "rm": "ch",
  "rn": "bi",
  "ru": "ru",
  "sg": "cf",
  "sr": "rs",
  "srr": "sn",
  "sn": "zw",
  "si": "lk",
  "sk": "sk",
  "sl": "si",
  "so": "so",
  "snk": "sn",
  "nr": "za",
  "st": "ls",
  "es": "es",
  "sw": {
    "proposed_iso_3166": "sw",
    "flag":
        "https://upload.wikimedia.org/wikipedia/commons/d/de/Flag_of_Swahili.gif",
    "name": "Swahili"
  },
  "ss": "sz",
  "sv": "se",
  "tl": "ph",
  "tg": "tj",
  "ta": "lk",
  "te": "in",
  "tet": "tl",
  "th": "th",
  "ti": "er",
  "tpi": "pg",
  "ts": "za",
  "tn": "bw",
  "tr": "tr",
  "tk": "tm",
  "uk": "ua",
  "umb": "ao",
  "ur": "pk",
  "uz": "uz",
  "ve": "za",
  "vi": "vn",
  "cy": "gb",
  "wo": "sn",
  "xh": "za",
  "yo": {
    "proposed_iso_3166": "yo",
    "flag":
        "https://upload.wikimedia.org/wikipedia/commons/0/04/Flag_of_the_Yoruba_people.svg",
    "name": "Yoruba"
  },
  "zu": "za",
  // Custom
  "zh_Hans": "cn",
  "zh_Hant": "cn",
  "fo": "fo",
  "bo": "bo",
  "to": "to",
};
