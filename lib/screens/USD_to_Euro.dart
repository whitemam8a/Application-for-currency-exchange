import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ExchangeUSD extends StatefulWidget {
  const ExchangeUSD({super.key});

  @override
  State<ExchangeUSD> createState() => _ExchangeUSDState();
}

class _ExchangeUSDState extends State<ExchangeUSD> {
  double _exchangeRate = 0.0;
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';

  Future<void> _fetchExchangeRate() async {
    String apiKey = 'fca_live_9TxTMI6OrtqQeSJifzLnofErRqyirKUexdiD4FXX';
    String url =
        'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&currencies=$_toCurrency&base_currency=$_fromCurrency';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      setState(() {
        _exchangeRate = responseData['data'][_toCurrency];
      });
    } catch (error) {
      print('Error fetching exchange rate: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
  }

  void _toggleCurrency() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _fetchExchangeRate();
  }

  void _refreshExchangeRate() {
    _fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshExchangeRate,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '1 $_fromCurrency = $_exchangeRate $_toCurrency',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleCurrency,
              child: Text('Toggle Currency'),
            ),
          ],
        ),
      ),
    );
  }
}
