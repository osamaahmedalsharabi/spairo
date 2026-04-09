import 'package:firebase_auth/firebase_auth.dart';

/// A comprehensive Firebase error handler that handles all types of Firebase errors
/// including Auth, Firestore, Storage, Functions, and Messaging errors.
class FirebaseErrorHandler {
  /// Main entry point for handling any Firebase exception
  static String getErrorMessage(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return _handleAuthError(exception);
    } else if (exception is FirebaseException) {
      return _handleFirebaseError(exception);
    } else if (exception is Exception) {
      final msg = exception.toString().replaceFirst('Exception: ', '');
      return msg;
    } else if (exception.toString().contains('firebase')) {
      return _handleGenericFirebaseError(exception.toString());
    } else {
      return "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // Firebase Authentication Errors
  // ============================================================
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      // Sign In Errors
      case 'invalid-email':
        return "البريد الإلكتروني غير صالح";
      case 'user-disabled':
        return "تم تعطيل هذا الحساب";
      case 'user-not-found':
        return "لا يوجد حساب بهذا البريد الإلكتروني";
      case 'wrong-password':
        return "كلمة المرور غير صحيحة";
      case 'invalid-credential':
        return "تحقق من البريد الإلكتروني وكلمة المرور";
      case 'invalid-verification-code':
        return "رمز التحقق غير صحيح";
      case 'invalid-verification-id':
        return "معرف التحقق غير صحيح";

      // Sign Up Errors
      case 'email-already-in-use':
        return "البريد الإلكتروني مستخدم مسبقًا";
      case 'weak-password':
        return "كلمة المرور ضعيفة جدًا، يجب أن تكون 6 أحرف على الأقل";
      case 'operation-not-allowed':
        return "هذا النوع من تسجيل الدخول غير مفعّل";

      // Password Reset Errors
      case 'expired-action-code':
        return "انتهت صلاحية رمز إعادة تعيين كلمة المرور";
      case 'invalid-action-code':
        return "رمز إعادة تعيين كلمة المرور غير صالح";

      // Phone Auth Errors
      case 'invalid-phone-number':
        return "رقم الهاتف غير صالح";
      case 'missing-phone-number':
        return "يرجى إدخال رقم الهاتف";
      case 'quota-exceeded':
        return "تم تجاوز الحد المسموح من رسائل SMS";
      case 'session-expired':
        return "انتهت صلاحية الجلسة، يرجى إعادة المحاولة";
      case 'code-expired':
        return "انتهت صلاحية رمز التحقق";

      // Account Management Errors
      case 'requires-recent-login':
        return "يرجى تسجيل الخروج وإعادة تسجيل الدخول للمتابعة";
      case 'credential-already-in-use':
        return "هذه البيانات مرتبطة بحساب آخر";
      case 'account-exists-with-different-credential':
        return "يوجد حساب بهذا البريد مرتبط بطريقة تسجيل مختلفة";
      case 'email-change-needs-verification':
        return "يرجى التحقق من البريد الإلكتروني الجديد";

      // Multi-factor Authentication Errors
      case 'multi-factor-auth-required':
        return "يرجى إكمال التحقق بخطوتين";
      case 'second-factor-already-in-use':
        return "عامل التحقق الثاني مستخدم مسبقاً";
      case 'maximum-second-factor-count-exceeded':
        return "تم الوصول للحد الأقصى من عوامل التحقق";

      // OAuth Errors
      case 'popup-blocked':
        return "تم حظر النافذة المنبثقة، يرجى السماح بها";
      case 'popup-closed-by-user':
        return "تم إغلاق نافذة تسجيل الدخول";
      case 'cancelled-popup-request':
        return "تم إلغاء طلب تسجيل الدخول";
      case 'missing-or-invalid-nonce':
        return "خطأ في عملية التحقق، يرجى إعادة المحاولة";

      // Network Errors
      case 'network-request-failed':
        return "فشل الاتصال، تحقق من اتصال الإنترنت";
      case 'too-many-requests':
        return "محاولات كثيرة جداً، يرجى الانتظار والمحاولة لاحقاً";
      case 'timeout':
        return "انتهت مهلة الطلب، يرجى المحاولة مرة أخرى";

      // User Token Errors
      case 'user-token-expired':
        return "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى";
      case 'invalid-user-token':
        return "جلسة غير صالحة، يرجى تسجيل الدخول مرة أخرى";
      case 'user-mismatch':
        return "نوع الحساب المختار لا يتطابق مع نوع حسابك الفعلي";

      // Provider Errors
      case 'provider-already-linked':
        return "هذا الحساب مرتبط مسبقاً بطريقة تسجيل أخرى";
      case 'no-such-provider':
        return "لا يوجد مزود الخدمة المطلوب";
      case 'invalid-api-key':
        return "خطأ في إعدادات التطبيق";

      // App Errors
      case 'app-not-authorized':
        return "التطبيق غير مصرح له";
      case 'app-not-installed':
        return "التطبيق غير مثبت";
      case 'captcha-check-failed':
        return "فشل التحقق من الكابتشا";
      case 'web-storage-unsupported':
        return "المتصفح لا يدعم التخزين المحلي";

      default:
        return "حدث خطأ في المصادقة، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // General Firebase Errors (Firestore, Storage, Functions, etc.)
  // ============================================================
  static String _handleFirebaseError(FirebaseException e) {
    final plugin = e.plugin.toLowerCase();

    // Route to specific handler based on plugin
    if (plugin.contains('firestore') || plugin.contains('cloud_firestore')) {
      return _handleFirestoreError(e);
    } else if (plugin.contains('storage') ||
        plugin.contains('firebase_storage')) {
      return _handleStorageError(e);
    } else if (plugin.contains('functions') ||
        plugin.contains('cloud_functions')) {
      return _handleFunctionsError(e);
    } else if (plugin.contains('messaging') ||
        plugin.contains('firebase_messaging')) {
      return _handleMessagingError(e);
    } else if (plugin.contains('auth') || plugin.contains('firebase_auth')) {
      // Handle as auth error if it's a FirebaseException from auth
      return _handleAuthErrorByCode(e.code);
    } else {
      return _handleGenericErrorByCode(e.code);
    }
  }

  // ============================================================
  // Cloud Firestore Errors
  // ============================================================
  static String _handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      // Permission Errors
      case 'permission-denied':
        return "ليس لديك صلاحية للوصول إلى هذه البيانات";
      case 'unauthenticated':
        return "يرجى تسجيل الدخول للمتابعة";

      // Data Errors
      case 'not-found':
        return "البيانات المطلوبة غير موجودة";
      case 'already-exists':
        return "هذه البيانات موجودة مسبقاً";
      case 'failed-precondition':
        return "لم تتحقق الشروط المطلوبة لتنفيذ العملية";
      case 'aborted':
        return "تم إلغاء العملية بسبب تعارض البيانات";
      case 'out-of-range':
        return "القيمة خارج النطاق المسموح";
      case 'data-loss':
        return "حدث فقدان في البيانات";

      // Resource Errors
      case 'resource-exhausted':
        return "تم تجاوز الحد المسموح، يرجى المحاولة لاحقاً";
      case 'cancelled':
        return "تم إلغاء العملية";
      case 'deadline-exceeded':
        return "انتهت مهلة الطلب، يرجى المحاولة مرة أخرى";

      // Server Errors
      case 'unavailable':
        return "الخدمة غير متوفرة حالياً، يرجى المحاولة لاحقاً";
      case 'internal':
        return "حدث خطأ داخلي في الخادم";
      case 'unimplemented':
        return "هذه الميزة غير مدعومة حالياً";
      case 'unknown':
        return "حدث خطأ غير معروف";

      // Validation Errors
      case 'invalid-argument':
        return "البيانات المدخلة غير صالحة";

      default:
        return "حدث خطأ في قاعدة البيانات، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // Firebase Storage Errors
  // ============================================================
  static String _handleStorageError(FirebaseException e) {
    switch (e.code) {
      // Object Errors
      case 'object-not-found':
        return "الملف المطلوب غير موجود";
      case 'bucket-not-found':
        return "مكان التخزين غير موجود";
      case 'project-not-found':
        return "المشروع غير موجود";

      // Quota Errors
      case 'quota-exceeded':
        return "تم تجاوز سعة التخزين المسموحة";

      // Authentication Errors
      case 'unauthenticated':
        return "يرجى تسجيل الدخول لرفع الملفات";
      case 'unauthorized':
        return "ليس لديك صلاحية لرفع هذا الملف";

      // Upload/Download Errors
      case 'retry-limit-exceeded':
        return "تجاوز حد المحاولات، يرجى إعادة المحاولة لاحقاً";
      case 'canceled':
        return "تم إلغاء العملية";
      case 'invalid-checksum':
        return "فشل التحقق من صحة الملف";
      case 'invalid-event-name':
        return "خطأ في معالجة الملف";
      case 'invalid-url':
        return "رابط الملف غير صالح";

      // File Errors
      case 'invalid-argument':
        return "خطأ في بيانات الملف";
      case 'no-default-bucket':
        return "لم يتم إعداد مكان التخزين";
      case 'cannot-slice-blob':
        return "فشل في معالجة الملف";

      // Server Errors
      case 'server-file-wrong-size':
        return "حجم الملف غير متطابق، يرجى إعادة الرفع";
      case 'unknown':
        return "حدث خطأ غير معروف أثناء رفع الملف";

      default:
        return "حدث خطأ في رفع الملف، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // Cloud Functions Errors
  // ============================================================
  static String _handleFunctionsError(FirebaseException e) {
    switch (e.code) {
      case 'ok':
        return "تمت العملية بنجاح";
      case 'cancelled':
        return "تم إلغاء العملية";
      case 'unknown':
        return "حدث خطأ غير معروف";
      case 'invalid-argument':
        return "البيانات المرسلة غير صالحة";
      case 'deadline-exceeded':
        return "انتهت مهلة الطلب";
      case 'not-found':
        return "الوظيفة المطلوبة غير موجودة";
      case 'already-exists':
        return "البيانات موجودة مسبقاً";
      case 'permission-denied':
        return "ليس لديك صلاحية لتنفيذ هذه العملية";
      case 'resource-exhausted':
        return "تم تجاوز الحد المسموح";
      case 'failed-precondition':
        return "لم تتحقق الشروط المطلوبة";
      case 'aborted':
        return "تم إلغاء العملية";
      case 'out-of-range':
        return "القيمة خارج النطاق المسموح";
      case 'unimplemented':
        return "هذه الميزة غير مدعومة";
      case 'internal':
        return "حدث خطأ داخلي في الخادم";
      case 'unavailable':
        return "الخدمة غير متوفرة حالياً";
      case 'data-loss':
        return "حدث فقدان في البيانات";
      case 'unauthenticated':
        return "يرجى تسجيل الدخول للمتابعة";

      default:
        return "حدث خطأ في تنفيذ العملية، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // Firebase Messaging Errors
  // ============================================================
  static String _handleMessagingError(FirebaseException e) {
    switch (e.code) {
      case 'messaging/invalid-registration-token':
        return "رمز التسجيل غير صالح";
      case 'messaging/registration-token-not-registered':
        return "رمز التسجيل غير مسجل";
      case 'messaging/invalid-package-name':
        return "اسم الحزمة غير صالح";
      case 'messaging/message-rate-exceeded':
        return "تم تجاوز حد الإشعارات";
      case 'messaging/topics-message-rate-exceeded':
        return "تم تجاوز حد إشعارات الموضوعات";
      case 'messaging/too-many-topics':
        return "تم تجاوز عدد الموضوعات المسموح";
      case 'messaging/invalid-argument':
        return "بيانات الإشعار غير صالحة";
      case 'messaging/internal-error':
        return "خطأ داخلي في خدمة الإشعارات";
      case 'messaging/permission-blocked':
        return "تم حظر إشعارات التطبيق";
      case 'messaging/notifications-blocked':
        return "الإشعارات محظورة من إعدادات الجهاز";
      case 'messaging/failed-service-worker-registration':
        return "فشل تسجيل خدمة الإشعارات";

      default:
        return "حدث خطأ في خدمة الإشعارات";
    }
  }

  // ============================================================
  // Helper Methods
  // ============================================================
  static String _handleAuthErrorByCode(String code) {
    // Re-use auth error handling for FirebaseException from auth plugin
    switch (code) {
      case 'network-request-failed':
        return "فشل الاتصال، تحقق من اتصال الإنترنت";
      case 'too-many-requests':
        return "محاولات كثيرة جداً، يرجى الانتظار والمحاولة لاحقاً";
      case 'user-token-expired':
        return "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى";
      default:
        return "حدث خطأ في المصادقة، يرجى المحاولة مرة أخرى";
    }
  }

  static String _handleGenericErrorByCode(String code) {
    switch (code) {
      case 'unavailable':
        return "الخدمة غير متوفرة حالياً، يرجى المحاولة لاحقاً";
      case 'permission-denied':
        return "ليس لديك صلاحية للوصول";
      case 'unauthenticated':
        return "يرجى تسجيل الدخول للمتابعة";
      case 'not-found':
        return "البيانات المطلوبة غير موجودة";
      case 'cancelled':
        return "تم إلغاء العملية";
      case 'deadline-exceeded':
        return "انتهت مهلة الطلب";
      case 'resource-exhausted':
        return "تم تجاوز الحد المسموح";
      case 'internal':
        return "حدث خطأ داخلي";
      default:
        return "حدث خطأ غير معروف، يرجى المحاولة مرة أخرى";
    }
  }

  static String _handleGenericFirebaseError(String errorString) {
    if (errorString.contains('network')) {
      return "فشل الاتصال، تحقق من اتصال الإنترنت";
    } else if (errorString.contains('permission') ||
        errorString.contains('denied')) {
      return "ليس لديك صلاحية للوصول";
    } else if (errorString.contains('not found') ||
        errorString.contains('not-found')) {
      return "البيانات المطلوبة غير موجودة";
    } else if (errorString.contains('timeout')) {
      return "انتهت مهلة الطلب";
    } else if (errorString.contains('unavailable')) {
      return "الخدمة غير متوفرة حالياً";
    } else {
      return "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى";
    }
  }

  // ============================================================
  // Utility Methods
  // ============================================================

  /// Check if the error is a network-related error
  static bool isNetworkError(dynamic exception) {
    if (exception is FirebaseException) {
      return exception.code == 'network-request-failed' ||
          exception.code == 'unavailable' ||
          exception.code == 'deadline-exceeded';
    }
    return false;
  }

  /// Check if the error requires re-authentication
  static bool requiresReAuth(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'requires-recent-login' ||
          exception.code == 'user-token-expired' ||
          exception.code == 'invalid-user-token';
    }
    return false;
  }

  /// Check if the error is a permission error
  static bool isPermissionError(dynamic exception) {
    if (exception is FirebaseException) {
      return exception.code == 'permission-denied' ||
          exception.code == 'unauthenticated' ||
          exception.code == 'unauthorized';
    }
    return false;
  }

  /// Check if the error is related to rate limiting
  static bool isRateLimitError(dynamic exception) {
    if (exception is FirebaseException) {
      return exception.code == 'too-many-requests' ||
          exception.code == 'resource-exhausted' ||
          exception.code == 'quota-exceeded';
    }
    return false;
  }

  /// Get suggested action for the error
  static String getSuggestedAction(dynamic exception) {
    if (isNetworkError(exception)) {
      return "تحقق من اتصال الإنترنت وحاول مرة أخرى";
    } else if (requiresReAuth(exception)) {
      return "قم بتسجيل الخروج وإعادة تسجيل الدخول";
    } else if (isPermissionError(exception)) {
      return "تأكد من تسجيل الدخول بحساب صحيح";
    } else if (isRateLimitError(exception)) {
      return "انتظر بضع دقائق ثم حاول مرة أخرى";
    } else {
      return "حاول مرة أخرى أو تواصل مع الدعم المهندس";
    }
  }
}
