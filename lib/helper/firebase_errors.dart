String getErrorString(String code){
  //PlatformExceptionでフリーズ。
  //PlatformExceptionをキャッチできないように見えるが実際はキャッチできている。
  //対応策、AndroidStudio > 実行 > ブレークポイント表示 > Break on exceptionsを使用可能にチェック。
  //https://python5.com/q/rkqqyfobを参照。その他ページも該当操作推進。
  switch (code) {
    case 'weak-password':
      return 'パスワードの安全性が低いです';
    case 'invalid-email':
      return 'メールアドレスが無効です';
    case 'email-already-in-use':
      return 'すでに別のアカウントで使用されています';
    case 'invalid-credential':
      return 'メールアドレスが無効です';
    case 'wrong-password':
      return 'パスワードが間違えています';
    case 'user-not-found':
      return 'このメールアドレスは登録されていません';
    case 'user-disabled':
      return 'このユーザーは無効になっています';
    case 'too-many-requests':
      return 'リクエストが多いです。後でもう一度お試しください';
    case 'operation-not-allowed':
      return '操作は許可されていません';

    default:
      return '予測不可能なエラーが発生しました';

  //下記、firebase公式。ただし、返されるエラーコードは小文字。バージョンアップから？

  //   case 'ERROR_WEAK_PASSWORD':
  //     return 'パスワードの安全性が低いです';
  //   case 'ERROR_INVALID_EMAIL':
  //     return 'メールアドレスが無効です';
  //   case 'ERROR_EMAIL_ALREADY_IN_USE':
  //     return 'すでに別のアカウントで使用されています';
  //   case 'ERROR_INVALID_CREDENTIAL':
  //     return 'メールアドレスが無効です';
  //   case 'ERROR_WRONG_PASSWORD':
  //     return 'パスワードが間違えています';
  //   case 'ERROR_USER_NOT_FOUND':
  //     return 'このメールアドレスは登録されていません';
  //   case 'ERROR_USER_DISABLED':
  //     return 'このユーザーは無効になっています';
  //   case 'ERROR_TOO_MANY_REQUESTS':
  //     return 'リクエストが多いです。後でもう一度お試しください';
  //   case 'ERROR_OPERATION_NOT_ALLOWED':
  //     return '操作は許可されていません';
  //
  //   default:
  //     return '予測不可能なエラーが発生しました';
  }

}