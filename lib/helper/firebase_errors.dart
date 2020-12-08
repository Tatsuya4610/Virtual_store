String getErrorString(String code){
  switch (code) {
    case 'ERROR_WEAK_PASSWORD':
      return 'パスワードの安全性が低いです';
    case 'ERROR_INVALID_EMAIL':
      return 'メールアドレスが無効です';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'すでに別のアカウントで使用されています';
    case 'ERROR_INVALID_CREDENTIAL':
      return 'メールアドレスが無効です';
    case 'ERROR_WRONG_PASSWORD':
      return 'パスワードが間違えています';
    case 'ERROR_USER_NOT_FOUND':
      return 'このメールアドレスは登録されていません';
    case 'ERROR_USER_DISABLED':
      return 'このユーザーは無効になっています';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'リクエストが多いです。後でもう一度お試しください';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return '操作は許可されていません';

    default:
      return '予測不可能なエラーが発生しました';
  }
}