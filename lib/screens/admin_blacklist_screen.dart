import 'package:flutter/material.dart';
import 'package:mobscan/core/appcolors.dart';

class AdminBlacklistScreen extends StatefulWidget {
  const AdminBlacklistScreen({super.key});

  @override
  State<AdminBlacklistScreen> createState() => _AdminBlacklistScreenState();
}

class _AdminBlacklistScreenState extends State<AdminBlacklistScreen> {
  final _appNameCtrl = TextEditingController();
  final _packageCtrl = TextEditingController();
  final _reasonCtrl  = TextEditingController();
  final _formKey     = GlobalKey<FormState>();
  bool _formVisible  = false;

  final List<Map<String, String>> _items = [];

  @override
  void dispose() {
    _appNameCtrl.dispose();
    _packageCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _add() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _items.insert(0, {
          'appName':     _appNameCtrl.text.trim(),
          'packageName': _packageCtrl.text.trim(),
          'reason':      _reasonCtrl.text.trim(),
        });
        _appNameCtrl.clear();
        _packageCtrl.clear();
        _reasonCtrl.clear();
        _formVisible = false;
      });
    }
  }

  void _delete(int index) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Remove "${_items[index]['appName']}"?',
          style: TextStyle(color: cs.onSurface),
        ),
        content: Text(
          'This will remove "${_items[index]['packageName']}" from the blacklist.',
          style: TextStyle(color: Appcolors.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: cs.onSurface)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _items.removeAt(index));
            },
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'Blacklist Manager',
            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: cs.onSurface),
          actions: [
            IconButton(
              onPressed: () => setState(() => _formVisible = !_formVisible),
              icon: Icon(_formVisible ? Icons.close : Icons.add, color: Colors.blue),
            ),
          ],
        ),
        body: Column(
            children: [
            // ─── Add Form ─────────────────────────────────────────────────
            if (_formVisible)
        Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: cs.tertiary,
    borderRadius: BorderRadius.circular(12),
    ),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    _Field(controller: _appNameCtrl, label: 'App Name',     hint: 'e.g. BadApp',          theme: theme),
    const SizedBox(height: 10),
    _Field(controller: _packageCtrl, label: 'Package Name', hint: 'e.g. com.bad.app',      theme: theme),
    const SizedBox(height: 10),
    _Field(controller: _reasonCtrl,  label: 'Reason',       hint: 'e.g. Contains malware', theme: theme, maxLines: 2),
    const SizedBox(height: 14),
    GestureDetector(
    onTap: _add,
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.block, color: Colors.white, size: 18),
    SizedBox(width: 8),
    Text('Add to Blacklist',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    )),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),

    // ─── Stats ────────────────────────────────────────────────────
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
    children: [
    Text('Total blocked: ${_items.length}',
    style: TextStyle(color: Appcolors.text)),
    const Spacer(),
    const Icon(Icons.circle, color: Colors.blue, size: 12),
    const SizedBox(width: 5),
    Text('live', style: TextStyle(color: Appcolors.text)),
    ],
    ),
    ),
    const SizedBox(height: 10),
    Divider(color: Colors.grey.shade700),
    const SizedBox(height: 10),
              // ─── List ─────────────────────────────────────────────────────
              Expanded(
                child: _items.isEmpty
                    ? Center(
                  child: Text('No packages blacklisted yet.',
                      style: TextStyle(color: Appcolors.text)),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: cs.tertiary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.block,
                                color: Colors.redAccent, size: 24),
                          ),
                          title: Text(
                            item['appName']!,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['packageName']!,
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 12)),
                              if (item['reason']!.isNotEmpty)
                                Text(item['reason']!,
                                    style: TextStyle(
                                        color: Appcolors.text, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => _delete(i),
                          ),
                          isThreeLine: item['reason']!.isNotEmpty,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
        ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.theme,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ThemeData theme;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: cs.onSurface, fontSize: 15),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.5)),
        hintStyle: TextStyle(color: Appcolors.text),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}