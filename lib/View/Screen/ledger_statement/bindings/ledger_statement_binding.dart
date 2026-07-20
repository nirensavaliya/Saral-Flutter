import 'package:get/get.dart';

import '../controllers/ledger_statement_controller.dart';

class LedgerStatementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LedgerStatementController>(
      () => LedgerStatementController(),
    );
  }
}
