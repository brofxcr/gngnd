import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const FinanceMonitorApp());
}

class FinanceMonitorApp extends StatelessWidget {
  const FinanceMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Фінансовий моніторинг',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const DashboardScreen(),
    );
  }
}

class Transaction {
  const Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
}

enum TransactionType { income, expense }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final currency = NumberFormat.currency(locale: 'uk_UA', symbol: '₴');

  final List<Transaction> _transactions = [
    Transaction(
      title: 'Зарплата',
      amount: 38000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.income,
      category: 'Дохід',
    ),
    Transaction(
      title: 'Продукти',
      amount: 2400,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      category: 'Харчування',
    ),
    Transaction(
      title: 'Комунальні платежі',
      amount: 1700,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.expense,
      category: 'Житло',
    ),
    Transaction(
      title: 'Фріланс-проєкт',
      amount: 9000,
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: TransactionType.income,
      category: 'Додатково',
    ),
  ];

  double get _totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get _totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double get _balance => _totalIncome - _totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фінансовий моніторинг')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryCard(
              balance: _balance,
              income: _totalIncome,
              expense: _totalExpense,
              currency: currency,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Останні операції',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  final isExpense = tx.type == TransactionType.expense;
                  final sign = isExpense ? '-' : '+';

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isExpense
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        child: Icon(
                          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isExpense
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                      title: Text(tx.title),
                      subtitle: Text(
                        '${tx.category} • ${DateFormat('dd.MM.yyyy').format(tx.date)}',
                      ),
                      trailing: Text(
                        '$sign${currency.format(tx.amount)}',
                        style: TextStyle(
                          color: isExpense ? Colors.red.shade700 : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.balance,
    required this.income,
    required this.expense,
    required this.currency,
  });

  final double balance;
  final double income;
  final double expense;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Поточний баланс', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              currency.format(balance),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: balance >= 0 ? Colors.teal : Colors.red,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  label: 'Дохід',
                  value: currency.format(income),
                  color: Colors.green,
                ),
                _StatItem(
                  label: 'Витрати',
                  value: currency.format(expense),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
