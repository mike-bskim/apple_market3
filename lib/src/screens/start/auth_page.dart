import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/common_size.dart';
import '../../constants/shared_pref_key.dart';
import '../../utils/logger.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const _duration_300 = Duration(microseconds: 300);
const _duration_1000 = Duration(seconds: 1);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  // 초기값을 010 으로 시작하게 설정
  final TextEditingController _phoneNumberController = TextEditingController(text: "010 5555 5555");

  final TextEditingController _codeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: 'authPage');

  // 인증단계 flag
  VerificationStatus _verificationStatus = VerificationStatus.none;

  String? _verificationId;
  int? _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    debugPrint(">>> build from AuthPage");

    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        // 인증 단계에서는 모든 클릭은 무시하게 처리
        return IgnorePointer(
          // 인증 단계에서는 화면의 모든 터치를 무시한다
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '전화번호 로그인',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(padding_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ExtendedImage.asset(
                          'assets/imgs/padlock.png',
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                        ),
                        const SizedBox(
                          width: padding_08,
                        ),
                        const Text('사과마켓은 휴대폰 번호로 가입해요 \n번호는 안전하게 보관되며 \n어디에도 공개되지 않아요.'),
                      ],
                    ),
                    const SizedBox(
                      height: padding_16,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      // 숫자자판이 나오게 설정
                      keyboardType: TextInputType.phone,
                      // 입력된 값의 형식을 지정, 지정된 형식 이상으로 입력되지 않음
                      inputFormatters: [MaskedInputFormatter('000 0000 0000')],
                      decoration: InputDecoration(
                        hintText: '전화번호 입력',
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        focusedBorder: inputBorder,
                        border: inputBorder,
                      ),
                      validator: (phoneNumber) {
                        // 전화번호 형식 검증
                        if (phoneNumber != null && phoneNumber.length == 13) {
                          return null;
                        } else {
                          return '전화번호 입력 오류입니다';
                        }
                      },
                    ),
                    const SizedBox(
                      height: padding_16,
                    ),
                    TextButton(
                        onPressed: () async {
                          debugPrint('_verificationStatus: $_verificationStatus');
                          _getAddress();
                          FocusScope.of(context).unfocus();
                          if (_verificationStatus == VerificationStatus.codeSending) {
                            return;
                          }
                          if (formKey.currentState != null) {
                            bool passed = formKey.currentState!.validate();
                            if (passed) {
                              var phoneNum = _phoneNumberController.text;
                              phoneNum = phoneNum.replaceAll(' ', '');
                              phoneNum = phoneNum.replaceFirst('0', '');
                              phoneNum = '+82$phoneNum';

                              setState(() {
                                // 인증단계 코드 전송중~~
                                _verificationStatus = VerificationStatus.codeSending;
                              });
// 중요 메인 로직 1/2
                              FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.verifyPhoneNumber(
                                phoneNumber: phoneNum,
                                forceResendingToken: _forceResendingToken,
                                verificationCompleted: (PhoneAuthCredential credential) async {
                                  // ANDROID ONLY!
                                  // login 이 정상적으로 완료되었는지 확인 코드 추가
                                  logger.d('전화번호 인증 완료 [$credential]');
                                  // 로그인이 정상완료되면 user 정보가 변경되어 스트림이 자동 호출됨
                                  await auth.signInWithCredential(credential);
                                },
                                // 기본값이 30초인데, time out 에러가 발생하여 지정해줌
                                timeout: const Duration(seconds: 30),
                                codeAutoRetrievalTimeout: (String verificationId) {
                                  // 현재는 아무것도 안한다.
                                },
                                codeSent: (String verificationId, int? forceResendingToken) async {
                                  setState(() {
                                    // 인증단계 전송완료~~, 전송이 완료되면 여기로 이동,
                                    _verificationStatus = VerificationStatus.codeSent;
                                  });
                                  // verificationId 값이 널이면 오류
                                  _verificationId = verificationId;
                                  // forceResendingToken 값은 첫번째 전송에서는 널, 그 이후는 값있음
                                  _forceResendingToken = forceResendingToken;
                                },
                                verificationFailed: (FirebaseAuthException error) {
                                  logger.d(error.message);
                                  setState(() {
                                    _verificationStatus = VerificationStatus.none;
                                  });
                                },
                              );
// 중요 메인 로직 1/2
                            } else {
                              setState(() {
                                _verificationStatus = VerificationStatus.none;
                              });
                            }
                          }
                          debugPrint('_verificationStatus: $_verificationStatus');
                        },
                        // 검증상태에 따라서 버튼의 문자열을 변경하여 동작중임을 표시함
                        child: _verificationStatus == VerificationStatus.codeSending
                            ? const SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(color: Colors.white))
                            : const Text('인증문자 발송')),
                    const SizedBox(height: padding_16 * 2),
                    AnimatedOpacity(
                      // 투명도를 설정하는 위젯
                      duration: _duration_300,
                      opacity: (_verificationStatus == VerificationStatus.none) ? 0.0 : 1.0,
                      child: AnimatedContainer(
                        // StatelessWidget 은 적용할수 없음, StatefulWidget 만 적용가능
                        duration: _duration_1000,
                        // 에니메이션이 조금 부자연스러워서 추가함
                        curve: Curves.easeInOut,
                        // 인증단계에 따라서 화면에 표시 여부를 정할수 있음
                        height: getVerificationHeight(_verificationStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.phone,
                          // 입력된 값의 형식을 지정, 지정된 형식 이상으로 입력되지 않음
                          inputFormatters: [MaskedInputFormatter('000000')],
                          decoration: InputDecoration(
                            hintText: '인증문자 입력',
                            hintStyle: TextStyle(color: Theme.of(context).hintColor),
                            focusedBorder: inputBorder,
                            border: inputBorder,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: padding_16),
                    AnimatedContainer(
                      duration: _duration_1000,
                      // 인증단계에 따라서 화면에 표시 여부를 정할수 있음
                      height: getVerificationBtnHeight(_verificationStatus),
                      child: TextButton(
                          onPressed: () {
                            debugPrint('_verificationStatus(onPressed): $_verificationStatus');
                            FocusScope.of(context).unfocus();
                            // 인증 진행중
                            attemptVarify(context);
                            debugPrint('_verificationStatus(onPressed): $_verificationStatus');
                          },
                          // 검증상태에 따라서 버튼의 문자열을 변경하여 동작중임을 표시함
                          child: _verificationStatus == VerificationStatus.verifying
                              ? const SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : const Text('인증')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double? getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0.0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60.0;
    }
  }

  double? getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0.0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48.0;
    }
  }

  void attemptVarify(BuildContext context) async {
    setState(() {
      // 인증 진행중
      _verificationStatus = VerificationStatus.verifying;
    });
    debugPrint('_verificationStatus(attemptVarify): $_verificationStatus');

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _codeController.text);
      // Sign the user in (or link) with the credential
      // 로그인이 정상완료되면 user 정보가 변경되어 스트림이 자동 호출됨
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e('verification failed !!!');
      SnackBar snackBar = const SnackBar(content: Text('입력하신 코드 오류입니다'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // Create a PhoneAuthCredential with the code

    setState(() {
      // 인증 완료
      _verificationStatus = VerificationStatus.verificationDone;
    });

    // // 이제는 user 상태가 자동으로 변하면서 로그인되므로 아래 부분은 필요없음
    // if (routerType == RouterType.beamer) {
    //   // context.read<UserProvider>().setUserAuth(true);
    //   // debugPrint('*** userState(attemptVarify): ${context.read<UserProvider>().userState}');
    // } else {
    //   if (UserController.to.user.value != null) {
    //     // UserController.to.setUserAuth(true);
    //   }
    // }

    debugPrint('_verificationStatus(attemptVarify): $_verificationStatus');
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString(SHARED_ADDRESS) ?? '';
    double lat = prefs.getDouble(SHARED_LAT) ?? 0.0;
    double lon = prefs.getDouble(SHARED_LON) ?? 0.0;
    debugPrint('get Address: [$address] [$lat] [$lon]');
  }
}

enum VerificationStatus { none, codeSending, codeSent, verifying, verificationDone }
