import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

export 'package:flutter_credit_card/flutter_credit_card.dart'
    show CreditCardModel;

/// Modified from https://pub.dev/packages/flutter_credit_card (see license below)

CreditCardModel emptyCreditCard() => CreditCardModel('', '', '', '', false);

class FlutterFlowCreditCardForm extends StatefulWidget {
  const FlutterFlowCreditCardForm({
    Key? key,
    required this.formKey,
    required this.creditCardModel,
    this.obscureNumber = false,
    this.obscureCvv = false,
    this.textStyle,
    this.spacing = 10.0,
    this.inputDecoration = const InputDecoration(
      border: OutlineInputBorder(),
    ),
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final CreditCardModel creditCardModel;
  final bool obscureNumber;
  final bool obscureCvv;
  final TextStyle? textStyle;
  final double spacing;
  final InputDecoration inputDecoration;

  @override
  _FlutterFlowCreditCardFormState createState() =>
      _FlutterFlowCreditCardFormState();
}

class _FlutterFlowCreditCardFormState extends State<FlutterFlowCreditCardForm> {
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();

  String get cardNumber => widget.creditCardModel.cardNumber;

  void textFieldFocusDidChange() {
    widget.creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
  }

  @override
  void initState() {
    super.initState();
    if (widget.creditCardModel.cardNumber.isNotEmpty) {
      _cardNumberController.text = widget.creditCardModel.cardNumber;
    }
    if (widget.creditCardModel.expiryDate.isNotEmpty) {
      _expiryDateController.text = widget.creditCardModel.expiryDate;
    }
    if (widget.creditCardModel.cvvCode.isNotEmpty) {
      _cvvCodeController.text = widget.creditCardModel.cvvCode;
    }
    cvvFocusNode.addListener(textFieldFocusDidChange);
    _cardNumberController.addListener(() => setState(
        () => widget.creditCardModel.cardNumber = _cardNumberController.text));
    _expiryDateController.addListener(() => setState(
        () => widget.creditCardModel.expiryDate = _expiryDateController.text));
    _cvvCodeController.addListener(() => setState(
        () => widget.creditCardModel.cvvCode = _cvvCodeController.text));
  }

  @override
  void dispose() {
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: TextFormField(
                obscureText: widget.obscureNumber,
                controller: _cardNumberController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(expiryDateNode),
                style: widget.textStyle,
                decoration: widget.inputDecoration.copyWith(
                  labelText: 'Card number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  labelStyle: widget.textStyle,
                  hintStyle: widget.textStyle,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  // Validate less that 13 digits +3 white spaces
                  if (value == null || value.isEmpty || value.length < 16) {
                    return 'Please input a valid number';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: widget.spacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: _expiryDateController,
                      focusNode: expiryDateNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(cvvFocusNode);
                      },
                      style: widget.textStyle,
                      decoration: widget.inputDecoration.copyWith(
                        labelText: 'Exp. Date',
                        hintText: 'MM/YY',
                        labelStyle: widget.textStyle,
                        hintStyle: widget.textStyle,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input a valid date';
                        }

                        final DateTime now = DateTime.now();
                        final List<String> date = value.split(RegExp(r'/'));
                        final int month = int.parse(date.first);
                        final int year = int.parse('20${date.last}');
                        final DateTime cardDate = DateTime(year, month);

                        if (cardDate.isBefore(now) ||
                            month > 12 ||
                            month == 0) {
                          return 'Please input a valid date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      obscureText: widget.obscureCvv,
                      focusNode: cvvFocusNode,
                      controller: _cvvCodeController,
                      style: widget.textStyle,
                      decoration: widget.inputDecoration.copyWith(
                        labelText: 'CVV',
                        hintText: 'XXX',
                        labelStyle: widget.textStyle,
                        hintStyle: widget.textStyle,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Please input a valid CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (type, patterns) {
        for (final patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr = cardNumber.replaceAll(RegExp(r's+|s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }
}

/// BSD 2-Clause License

/// Copyright (c) 2019, Simform Solutions
/// All rights reserved.

/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions are met:

/// 1. Redistributions of source code must retain the above copyright notice, this
///    list of conditions and the following disclaimer.

/// 2. Redistributions in binary form must reproduce the above copyright notice,
///    this list of conditions and the following disclaimer in the documentation
///    and/or other materials provided with the distribution.

/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
/// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
/// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
/// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
/// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
/// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
/// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
/// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
/// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
