import 'package:flutter/material.dart';

import '../../cores/themes/text_styles.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final String hintText;
  final bool enabled;
  final Function(T? value)? onChanged;
  final Widget Function(BuildContext context, T item)? itemBuilder;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.hintText,
    this.enabled = true,
    this.onChanged,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 6.0),

        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<T>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: AppTextStyles.caption.copyWith(fontSize: 14),
            ),
            initialValue: value,
            onChanged: enabled ? onChanged : null,
            style: AppTextStyles.bodyMedium,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: itemBuilder != null
                    ? itemBuilder!(context, item)
                    : Text(
                        item.toString(),
                        style: AppTextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: !enabled,
              fillColor: enabled ? null : Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }
}
