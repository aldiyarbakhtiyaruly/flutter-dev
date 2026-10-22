import 'package:flutter/material.dart';
import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }
}

const groups = [
  'IT-2301',
  'IT-2302',
  'IT-2303',
  'IT-2304',
  'IT-2305',
];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;
  int _passwordLength = 0;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirm,
      _birthController,
    ]) {
      controller.dispose();
    }

    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created'),
        ),
      );

      setState(() {
        _done = true;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _birth = picked;

      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();

      _birthController.text = '$day.$month.$year';
    });
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();

      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
      _passwordLength = 0;
    });
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    String? helper,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create your account',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill in the information below.',
            ),
            const SizedBox(height: 24),

            // NAME
            TextFormField(
              controller: _name,
              decoration: _decoration(label: 'Name'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                _emailFocus.requestFocus();
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (v) {
                if ((v ?? '').trim().length < 2) {
                  return 'Name is too short';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // EMAIL
            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              decoration: _decoration(
                label: 'Email',
                hint: 'name@kbtu.kz',
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              onFieldSubmitted: (_) {
                FocusScope.of(context).nextFocus();
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (v) {
                final email = (v ?? '').trim();
                final atIndex = email.indexOf('@');

                if (atIndex <= 0 ||
                    !email.substring(atIndex + 1).contains('.')) {
                  return 'Email looks wrong';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextFormField(
              controller: _password,
              decoration: _decoration(
                label: 'Password',
                helper: 'At least 8 characters',
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() {
                  _passwordLength = value.length;
                });
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).nextFocus();
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (v) {
                if ((v ?? '').length < 8) {
                  return 'Password is too short';
                }
                return null;
              },
            ),

            const SizedBox(height: 6),

            Text(
              '$_passwordLength of 8',
              style: TextStyle(
                color: _passwordLength >= 8
                    ? Colors.green
                    : Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // CONFIRM PASSWORD
            TextFormField(
              controller: _confirm,
              decoration: _decoration(
                label: 'Confirm password',
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_agreed) {
                  _submit();
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (v) {
                if ((v ?? '') != _password.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // GROUP
            DropdownButtonFormField<String>(
              initialValue: _group,
              decoration: _decoration(label: 'Group'),
              items: [
                for (final group in groups)
                  DropdownMenuItem(
                    value: group,
                    child: Text(group),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _group = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Choose a group';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // DATE OF BIRTH
            TextFormField(
              controller: _birthController,
              readOnly: true,
              decoration: _decoration(
                label: 'Date of birth',
                hint: 'dd.mm.yyyy',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
              validator: (_) {
                if (_birth == null) {
                  return 'Choose your date of birth';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // CHECKBOX
            CheckboxListTile(
              title: const Text('I agree to the rules'),
              value: _agreed,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _agreed = value ?? false;
                });
              },
            ),

            const SizedBox(height: 24),

            // SIGN UP BUTTON
            FilledButton(
              onPressed: _agreed ? _submit : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 70,
          ),
          const SizedBox(height: 16),
          const Text(
            'Account created!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          SummaryCard(
            name: _name.text.trim(),
            email: _email.text.trim(),
            group: _group ?? '',
            birthDate: _birthController.text,
          ),

          const SizedBox(height: 24),

          TextButton(
            onPressed: _startOver,
            child: const Text('Start over'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: _done ? _buildSummary() : _buildForm(),
    );
  }
}
