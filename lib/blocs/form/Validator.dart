import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Validators {
  final StreamTransformer<String, String> validateEmail =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String email, EventSink<String> sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String password, EventSink<String> sink) {
    if (password.length > 2) {
      sink.add(password);
    } else {
      sink.addError('Invalid password, please enter more than 2 characters');
    }
  });

  final StreamTransformer<String, String> validatePhone =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String phone, EventSink<String> sink) {
    const String pattern = r'(^[0-9]*$)';
    final RegExp regExp = RegExp(pattern);
    if (phone.isEmpty) {
      sink.addError('Mobile number is Required');
    } else if (phone.length != 10) {
      sink.addError('Mobile number must 10 digits');
    } else if (!regExp.hasMatch(phone)) {
      sink.addError('Mobile Number must be digits');
    } else {
      sink.add(phone);
    }
  });

  final StreamTransformer<String, String> validateName =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String name, EventSink<String> sink) {
    const String pattern = r'(^[a-zA-Z ]*$)';
    final RegExp regExp = RegExp(pattern);
    if (name.isEmpty) {
      sink.addError('Name is Required');
    } else if (!regExp.hasMatch(name)) {
      sink.addError('Name must be a-z and A-Z');
    } else {
      sink.add(name);
    }
  });
}

class LoginValidationBloc extends Validators {
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneController = BehaviorSubject<String>();
  final BehaviorSubject<String> _whatsAppNoController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final PublishSubject<bool> _loadingData = PublishSubject<bool>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeWhatsAppNo => _whatsAppNoController.sink.add;
  Function(String) get changeName => _nameController.sink.add;

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get phone => _phoneController.stream.transform(validatePhone);
  Stream<String> get whatsAppNo =>
      _whatsAppNoController.stream.transform(validatePhone);
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid => Rx.combineLatest2(
      email, password, (String email, String password) => true);

  void submit() {
    _loadingData.sink.add(true);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _phoneController.close();
    _whatsAppNoController.close();
  }
}
