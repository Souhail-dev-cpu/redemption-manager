import 'package:flutter/material.dart';
import '../models/redemption.dart';

class RedemptionCard extends StatelessWidget {
  final Redemption redemption;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDelete;

  const RedemptionCard({
    super.key,
    required this.redemption,
    required this.onStatusChanged,
    required this.onDelete,
  });

  Color _getStatusColor() {
    switch (redemption.status) {
      case 'Approvata':
        return Colors.green;
      case 'Rifiutata':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    redemption.userId,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Elimina',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const Divider(),
            Text('Reward: ${redemption.rewardType}'),
            const SizedBox(height: 6),
            Text('Importo: € ${redemption.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Stato:',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: redemption.status,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'In attesa',
                        child: Text('In attesa'),
                      ),
                      DropdownMenuItem(
                        value: 'Approvata',
                        child: Text('Approvata'),
                      ),
                      DropdownMenuItem(
                        value: 'Rifiutata',
                        child: Text('Rifiutata'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onStatusChanged(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
