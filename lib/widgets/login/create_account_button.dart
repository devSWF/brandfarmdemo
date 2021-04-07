import 'package:flutter/material.dart';
import 'package:BrandFarm/repository/user/user_repository.dart';
import 'package:BrandFarm/testpage.dart';

class CreateAccountButton extends StatelessWidget {
  // final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        // _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        '아직 회원이 아니신가요?',
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[700]),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) {
            return TestPage();
            // return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}
