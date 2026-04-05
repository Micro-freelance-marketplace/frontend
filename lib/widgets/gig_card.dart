import 'package:flutter/material.dart';

import '../models/gig.dart';

class GigCard extends StatelessWidget {
  final Gig gig;

  const GigCard({super.key, required this.gig});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(gig.title),
        subtitle: Text('${gig.category} • by ${gig.sellerName}'),
        trailing: Text(
          gig.budget,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
