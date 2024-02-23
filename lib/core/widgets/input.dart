import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final int? maxLines;
  final bool autoFocus;
  final bool readOnly;
  final Function()? onTap;

  const InputField({
    Key? key,
    this.controller,
    required this.label,
    this.maxLines,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            child: TextFormField(
              controller: controller,
              autofocus: autoFocus,
              maxLines: maxLines,
              readOnly: readOnly,
              onTap: onTap,
              decoration: InputDecoration(
                fillColor: const Color(0xFFF7F8F9),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDADADA)),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // Example color
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                hintText: label,
                labelStyle: const TextStyle(color: Color(0xFF8391A1)),
              ),
              validator: (value) => _validateField(value, label),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateField(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $label';
    }
    return null;
  }
}
