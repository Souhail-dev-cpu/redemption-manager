import 'package:flutter/material.dart';
import '../models/redemption.dart';

class AddRedemptionScreen extends StatefulWidget {
  const AddRedemptionScreen({super.key});

  @override
  State<AddRedemptionScreen> createState() => _AddRedemptionScreenState();
}

class _AddRedemptionScreenState extends State<AddRedemptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userIdController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedReward = 'Buono Amazon';
  String _selectedStatus = 'In attesa';

  final List<String> _rewardTypes = [
    'Buono Amazon',
    'Buono carburante',
    'Sconto',
    'Premio in denaro',
  ];

  final List<String> _statuses = ['In attesa', 'Approvata', 'Rifiutata'];

  @override
  void dispose() {
    _userIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveRedemption() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Accetta sia la virgola sia il punto come separatore decimale.
    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    final redemption = Redemption(
      userId: _userIdController.text.trim(),
      rewardType: _selectedReward,
      amount: amount,
      status: _selectedStatus,
    );

    Navigator.pop(context, redemption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova redemption')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'ID utente',
                  hintText: 'Esempio: UTENTE001',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci l’ID utente';
                  }

                  if (value.trim().length < 3) {
                    return 'L’ID deve contenere almeno 3 caratteri';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedReward,
                decoration: const InputDecoration(
                  labelText: 'Tipo di reward',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
                items: _rewardTypes.map((reward) {
                  return DropdownMenuItem(value: reward, child: Text(reward));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedReward = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Importo',
                  hintText: 'Esempio: 25,50',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.euro),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci un importo';
                  }

                  final amount = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );

                  if (amount == null) {
                    return 'Inserisci un numero valido';
                  }

                  if (amount <= 0) {
                    return 'L’importo deve essere maggiore di zero';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Stato della richiesta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveRedemption,
                icon: const Icon(Icons.save),
                label: const Text('Salva redemption'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
