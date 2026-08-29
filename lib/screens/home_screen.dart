import 'package:flutter/material.dart';
import '../models/redemption.dart';
import '../widgets/redemption_card.dart';
import 'add_redemption_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Redemption> _redemptions = [];

  String _selectedStatus = 'Tutti';
  String _searchText = '';

  List<Redemption> get _filteredRedemptions {
    return _redemptions.where((redemption) {
      final matchesStatus =
          _selectedStatus == 'Tutti' || redemption.status == _selectedStatus;

      final search = _searchText.toLowerCase();

      final matchesSearch =
          redemption.userId.toLowerCase().contains(search) ||
          redemption.rewardType.toLowerCase().contains(search);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<void> _openAddScreen() async {
    final result = await Navigator.push<Redemption>(
      context,
      MaterialPageRoute(builder: (context) => const AddRedemptionScreen()),
    );

    if (result != null) {
      setState(() {
        _redemptions.add(result);
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Redemption aggiunta correttamente')),
      );
    }
  }

  void _deleteRedemption(Redemption redemption) {
    setState(() {
      _redemptions.remove(redemption);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Redemption eliminata')));
  }

  void _changeStatus(Redemption redemption, String newStatus) {
    setState(() {
      redemption.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRedemptions = _filteredRedemptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redemption Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cerca',
                hintText: 'ID utente o reward',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Filtra per stato',
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Tutti', child: Text('Tutti')),
                DropdownMenuItem(value: 'In attesa', child: Text('In attesa')),
                DropdownMenuItem(value: 'Approvata', child: Text('Approvata')),
                DropdownMenuItem(value: 'Rifiutata', child: Text('Rifiutata')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: filteredRedemptions.isEmpty
                ? const Center(
                    child: Text(
                      'Nessuna redemption trovata',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRedemptions.length,
                    itemBuilder: (context, index) {
                      final redemption = filteredRedemptions[index];

                      return RedemptionCard(
                        redemption: redemption,
                        onStatusChanged: (newStatus) {
                          _changeStatus(redemption, newStatus);
                        },
                        onDelete: () {
                          _deleteRedemption(redemption);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddScreen,
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi'),
      ),
    );
  }
}
