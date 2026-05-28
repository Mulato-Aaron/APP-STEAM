import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/models/game.dart';

class ProductForm extends StatefulWidget {
  final Game? game;

  const ProductForm({super.key, this.game});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late double _price;
  late String _imageUrl;
  late String _category;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _title = widget.game?.title ?? '';
    _description = widget.game?.description ?? '';
    _price = widget.game?.price ?? 0.0;
    _imageUrl = widget.game?.imageUrl ?? '';
    _category = widget.game?.category ?? '';
    _stock = widget.game?.stock ?? 0;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final dbService = Provider.of<DatabaseService>(context, listen: false);
      final newGame = Game(
        id: widget.game?.id,
        title: _title,
        description: _description,
        price: _price,
        imageUrl: _imageUrl,
        category: _category,
        stock: _stock,
      );

      if (widget.game == null) {
        dbService.addGame(newGame);
      } else {
        dbService.updateGame(newGame);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => _stock = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.game == null ? 'Añadir' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
