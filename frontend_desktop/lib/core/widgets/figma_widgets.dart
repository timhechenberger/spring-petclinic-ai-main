import 'package:flutter/material.dart';

/// Shared page structure: title + toolbar row + content
class FigmaPage extends StatelessWidget {
  final String title;
  final List<Widget> toolbarItems; // search field, buttons etc.
  final Widget content;

  const FigmaPage({
    super.key,
    required this.title,
    required this.toolbarItems,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(children: toolbarItems),
          const SizedBox(height: 16),
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// Grey search field like Figma
class FigmaSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const FigmaSearchField({super.key, required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 38,
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
            prefixIcon: const Icon(Icons.search, size: 18, color: Colors.black45),
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

/// Grey button like Figma
class FigmaButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool enabled;

  const FigmaButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.black38,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

/// Table card like Figma - white card with grey header, footer buttons
class FigmaTableCard extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<Widget> footerActions;

  const FigmaTableCard({
    super.key,
    required this.columns,
    required this.rows,
    this.footerActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey.shade500),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                  columnSpacing: 28,
                  horizontalMargin: 16,
                  columns: columns,
                  rows: rows,
                ),
              ),
            ),
          ),
          if (footerActions.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade400)),
              ),
              child: Row(children: footerActions),
            ),
          ],
        ],
      ),
    );
  }
}

/// Standard form dialog - Figma style
class FigmaDialog extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onConfirm;
  final String confirmLabel;

  const FigmaDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onConfirm,
    required this.confirmLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 18),
              ...fields,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F7F46),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple labeled text field for dialogs
class FigmaField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;

  const FigmaField({super.key, required this.label, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFBDBDBD))),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF3F7F46), width: 1.5)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            ),
          ),
        ],
      ),
    );
  }
}