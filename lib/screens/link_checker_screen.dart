import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/link_check_controller/link_checker_cubit.dart';
import '../core/appcolors.dart';
import '../models/vt_link_result.dart';

class LinkCheckerScreen extends StatelessWidget {
  const LinkCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LinkCheckerCubit(),
      child: const _LinkCheckerView(),
    );
  }
}

class _LinkCheckerView extends StatefulWidget {
  const _LinkCheckerView();

  @override
  State<_LinkCheckerView> createState() => _LinkCheckerViewState();
}

class _LinkCheckerViewState extends State<_LinkCheckerView> {
  final _urlCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  void _scan() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<LinkCheckerCubit>().scanLink(_urlCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Link Checker',
            style:
            TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      body: BlocBuilder<LinkCheckerCubit, LinkCheckerState>(
        builder: (context, state) {
          final isScanning = state.status == LinkCheckerStatus.loading;

          return Column(
            children: [
              // ─── Input Card ───────────────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                      TextFormField(
                        controller: _urlCtrl,
                        style: TextStyle(color: cs.onSurface, fontSize: 15),
                        keyboardType: TextInputType.url,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter a URL';
                          }
                          if (!v.trim().startsWith('http')) {
                            return 'URL must start with http:// or https://';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'https://example.com',
                          hintStyle: TextStyle(color: Appcolors.text),
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          prefixIcon: Icon(Icons.link, color: Appcolors.text),
                          suffixIcon: _urlCtrl.text.isNotEmpty
                              ? IconButton(
                            icon:
                            Icon(Icons.clear, color: Appcolors.text),
                            onPressed: () {
                              _urlCtrl.clear();
                              setState(() {});
                            },
                          )
                              : null,
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
                            borderSide:
                            const BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            const BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Paste button
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final data =
                                await Clipboard.getData('text/plain');
                                if (data?.text != null) {
                                  _urlCtrl.text = data!.text!;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.content_paste,
                                        color: Appcolors.text, size: 16),
                                    const SizedBox(width: 6),
                                    Text('Paste',
                                        style:
                                        TextStyle(color: Appcolors.text)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Scan button
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: isScanning ? null : _scan,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: isScanning
                                    ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  ),
                                )
                                    : const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shield_outlined,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 6),
                                    Text('Check Link',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ─── Result Card ──────────────────────────────────────────
              if (state.status == LinkCheckerStatus.success &&
                  state.result != null)
                _ResultCard(result: state.result!, theme: theme),

              if (state.status == LinkCheckerStatus.error)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(state.error ?? 'Scan failed.',
                              style:
                              const TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  ),
                ),

              // ─── History ──────────────────────────────────────────────
              if (state.history.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Row(
                    children: [
                      Text('Recent Scans',
                          style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            context.read<LinkCheckerCubit>().clearHistory(),
                        child: Text('Clear',
                            style: TextStyle(
                                color: Appcolors.text, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade700),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.history.length,
                    itemBuilder: (context, i) => _HistoryTile(
                        result: state.history[i], theme: theme),
                  ),
                ),
              ] else
                const Spacer(),
            ],
          );
        },
      ),
    );
  }
}

// ─── Full Result Card ─────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.theme});

  final VtLinkResult result;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final statusColor = result.isMalicious
        ? Colors.redAccent
        : result.suspicious > 0
        ? Colors.orange
        : Colors.green;
    final statusText = result.isMalicious
        ? 'Malicious'
        : result.suspicious > 0
        ? 'Suspicious'
        : 'Clean';
    final statusIcon = result.isMalicious
        ? Icons.dangerous_outlined
        : result.suspicious > 0
        ? Icons.warning_amber_outlined
        : Icons.verified_outlined;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.tertiary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(statusIcon, color: statusColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(statusText,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(
                      '${result.malicious + result.suspicious} / ${result.total} engines flagged',
                      style: TextStyle(color: Appcolors.text, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // URL
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(result.url,
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats chips
          Row(
            children: [
              _Chip(
                  label: 'Malicious',
                  value: result.malicious,
                  color: Colors.redAccent),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Suspicious',
                  value: result.suspicious,
                  color: Colors.orange),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Harmless',
                  value: result.harmless,
                  color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── History Tile ─────────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.result, required this.theme});

  final VtLinkResult result;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final statusColor = result.isMalicious
        ? Colors.redAccent
        : result.suspicious > 0
        ? Colors.orange
        : Colors.green;
    final statusIcon = result.isMalicious
        ? Icons.dangerous_outlined
        : result.suspicious > 0
        ? Icons.warning_amber_outlined
        : Icons.verified_outlined;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: cs.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 22),
          ),
          title: Text(result.url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          subtitle: Text(
            '${result.malicious + result.suspicious} / ${result.total} detections',
            style: TextStyle(color: Appcolors.text, fontSize: 11),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              result.isMalicious
                  ? 'Malicious'
                  : result.suspicious > 0
                  ? 'Suspicious'
                  : 'Clean',
              style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.label, required this.value, required this.color});

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label: $value',
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}