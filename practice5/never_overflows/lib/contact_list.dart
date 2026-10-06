import 'package:flutter/material.dart';
import 'package:never_overflows/contact_card.dart';
import 'package:never_overflows/contacts.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ContactCard(contact: contacts[index]);
      },

      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
