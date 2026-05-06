import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return ListView.builder(
      itemCount: itemProvider.items.length,
      itemBuilder: (context, index) {
        final item = itemProvider.items[index];
        return ListTile(
          title: Text(item.name),
          trailing: Checkbox(
            value: item.isBought,
            onChanged: (value) => itemProvider.toggleItem(item.id),
          ),
        );
      },
    );
  }
}
