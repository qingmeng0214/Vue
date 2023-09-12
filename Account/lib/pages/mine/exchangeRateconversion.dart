import 'package:flutter/material.dart';

class exchangeRateconversion extends StatefulWidget {
  const exchangeRateconversion({Key? key}) : super(key: key);

  @override
  State<exchangeRateconversion> createState() => _exchangeRateconversionState();

}

class _exchangeRateconversionState extends State<exchangeRateconversion> {
  final List<Map<String, String>> _currencies = [
    {'name': 'CNY', 'displayName': '人民币', 'flag': '🇨🇳'},
    {'name': 'HKD', 'displayName': '港币', 'flag': '🇭🇰'},
    {'name': 'USD', 'displayName': '美元', 'flag': '🇺🇸'},
    {'name': 'GBP', 'displayName': '英镑', 'flag': '🇬🇧'},
    {'name': 'JPY', 'displayName': '日元', 'flag': '🇯🇵'},
    {'name': 'EUR', 'displayName': '欧元', 'flag': '🇪🇺'},
    {'name': 'RUB', 'displayName': '卢布', 'flag': '🇷🇺'},
    {'name': 'KRW', 'displayName': '韩元', 'flag': '🇰🇷'},
    {'name': 'ARS', 'displayName': '比索', 'flag': '🇦🇷'},
  ];

  Map<String, double> _exchangeRates = {
    'CNY': 1.0,
    'HKD': 8.064516,
    'USD': 6.493506,
    'GBP': 9.0090090,
    'JPY': 0.0619962802231866,
    'EUR': 7.692307,
    'RUB': 0.08833,
    'KRW': 0.00564,
    'ARS': 0.065402223675605,
  };

  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _currencies.forEach((currency) {
      _exchangeRates[currency['name']!] ??= 1.0;
      _controllers[currency['name']!] = TextEditingController(text: '0.00');
    });
  }

  Widget _buildExchangeRateRow(Map<String, String> currency) {
    final TextEditingController controller =
        _controllers[currency['name']] ?? TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Container(
        height: 60,
        width: 372,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20),
            Text(
              currency['flag']!,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(width: 20),
            Text(currency['displayName']!),
            SizedBox(width: 90),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '0.00',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: controller,
                onTap: () {
                  controller.clear();
                },
                onChanged: (value) {
                  double amount = double.tryParse(value) ?? 0.0;
                  _controllers.forEach((key, controller) {
                    if (key != currency['name']) {
                      double rate = _exchangeRates[currency['name']!]! /
                          _exchangeRates[key]!;
                      controller.text = (amount * rate).toStringAsFixed(2);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('汇率换算'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(255, 153, 102, 1),
                  Color.fromRGBO(255, 94, 98, 1)
                ]),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildExchangeRateRow(_currencies[index]);
        },
      ),
    );
  }
}
