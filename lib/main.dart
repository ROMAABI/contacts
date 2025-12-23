import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> _contacts = [
    Contact(name: "Ariharan", phoneNumber: "1234567890"),
    Contact(name: "abimanyu", phoneNumber: "1234512345"),
    Contact(name: "diya", phoneNumber: "5554443333"),
    Contact(name: "nishi", phoneNumber: "6464346436"),
    Contact(name: "danvi", phoneNumber: "5373473753"),
    Contact(name: "sridevi", phoneNumber: "555-444-5555"),
    Contact(name: "Ajith", phoneNumber: "1234509876"),
    Contact(name: "vijay", phoneNumber: "98576475675"),
  ];

  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts 👤'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 45, 45, 45)],
          ),
        ),
        child: _contacts.isEmpty
            ? const Center(
                child: Text('No contacts yet.',
                    style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    color: Colors.grey.shade900,
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          contact.name.isNotEmpty
                              ? contact.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(contact.phoneNumber,
                          style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Calling ${contact.name}...")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push<Contact>(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );
          if (newContact != null) {
            _addContact(newContact);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
      );
      Navigator.pop(context, contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveContact,
                child: const Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
