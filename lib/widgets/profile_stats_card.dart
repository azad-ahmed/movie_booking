import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  final int totalBookings;
  final String favoriteGenre;
  final double savedMoney;

  const ProfileStatsCard({
    Key? key,
    required this.totalBookings,
    required this.favoriteGenre,
    required this.savedMoney,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatColumn(
              context,
              totalBookings.toString(),
              'Buchungen',
              Icons.movie_rounded,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatColumn(
              context,
              favoriteGenre,
              'Lieblings-Genre',
              Icons.favorite_rounded,
              Colors.red,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatColumn(
              context,
              '${savedMoney.toStringAsFixed(0)} CHF',
              'Gespart',
              Icons.savings_rounded,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}