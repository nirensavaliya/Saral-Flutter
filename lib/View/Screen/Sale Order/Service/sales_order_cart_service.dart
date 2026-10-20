import '../../../../Common/Get_Storage.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/sales_order_cart_model.dart';

class SalesOrderCartService {
  static const String _storageKey = 'sales_order_cart';

  static Future<void> save({
    required List<SaleOrderDetails> items,
    required String total,
    required String discountTotal,
    required String cGstTotal,
    required String sGstTotal,
    required String iGstTotal,
    required String totalItem,
    required String netTotal,
    String? orderNo,
    int? customerId,
    String? customerName,
    bool mergeIntoToday = false,
  }) {
    if (items.isEmpty) {
      return Future.value();
    }

    final carts = loadAll();
    if (mergeIntoToday) {
      final todayCarts = carts
          .where(
            (cart) =>
                _isSameCalendarDay(cart.savedAt) &&
                _sameCartCustomer(cart, customerId, customerName),
          )
          .toList();

      if (todayCarts.isNotEmpty) {
        final keep = todayCarts.first;
        var mergedItems = <SaleOrderDetails>[];
        for (final todayCart in todayCarts) {
          mergedItems = _mergeLineItems(mergedItems, todayCart.items);
        }
        mergedItems = _mergeLineItems(mergedItems, items);
        final totals = _totalsFromItems(mergedItems);

        final mergedCart = SalesOrderCartModel(
          cartId: keep.cartId,
          items: mergedItems,
          total: totals['total']!,
          discountTotal: totals['discountTotal']!,
          cGstTotal: totals['cGstTotal']!,
          sGstTotal: totals['sGstTotal']!,
          iGstTotal: totals['iGstTotal']!,
          totalItem: totals['totalItem']!,
          netTotal: totals['netTotal']!,
          orderNo: keep.orderNo ?? orderNo,
          customerId: keep.customerId ?? customerId,
          customerName: keep.customerName ?? customerName,
          savedAt: keep.savedAt ?? DateTime.now().toIso8601String(),
        );

        final todayIds = todayCarts.map((c) => c.cartId).toSet();
        final remaining = carts
            .where((cart) => !todayIds.contains(cart.cartId))
            .toList();
        remaining.insert(0, mergedCart);

        return GetStorageData.saveObject(
          _storageKey,
          remaining.map((e) => e.toJson()).toList(),
        );
      }
    }

    final cart = SalesOrderCartModel(
      cartId: DateTime.now().microsecondsSinceEpoch.toString(),
      items: items,
      total: total,
      discountTotal: discountTotal,
      cGstTotal: cGstTotal,
      sGstTotal: sGstTotal,
      iGstTotal: iGstTotal,
      totalItem: totalItem,
      netTotal: netTotal,
      orderNo: orderNo,
      customerId: customerId,
      customerName: customerName,
      savedAt: DateTime.now().toIso8601String(),
    );
    carts.insert(0, cart);
    return GetStorageData.saveObject(
      _storageKey,
      carts.map((e) => e.toJson()).toList(),
    );
  }

  static bool _isSameCalendarDay(String? iso) {
    if (iso == null || iso.trim().isEmpty) return false;
    final dt = DateTime.tryParse(iso);
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static bool _sameCartCustomer(
    SalesOrderCartModel cart,
    int? customerId,
    String? customerName,
  ) {
    if (customerId != null && cart.customerId != null) {
      return cart.customerId == customerId;
    }
    return (cart.customerName ?? '').trim() == (customerName ?? '').trim();
  }

  static bool _isSameLine(SaleOrderDetails a, SaleOrderDetails b) {
    return a.itemId != null &&
        b.itemId != null &&
        a.itemId == b.itemId &&
        (a.unit ?? '') == (b.unit ?? '');
  }

  static List<SaleOrderDetails> _mergeLineItems(
    List<SaleOrderDetails> existing,
    List<SaleOrderDetails> incoming,
  ) {
    final merged = List<SaleOrderDetails>.from(existing);
    for (final item in incoming) {
      final index = merged.indexWhere((e) => _isSameLine(e, item));
      if (index == -1) {
        merged.add(item);
        continue;
      }
      final old = merged[index];
      merged[index] = SaleOrderDetails(
        itemId: old.itemId,
        itemName: old.itemName ?? item.itemName,
        unit: old.unit ?? item.unit,
        qty: (old.qty ?? 0) + (item.qty ?? 0),
        price: old.price ?? item.price,
        discountPer: old.discountPer ?? item.discountPer,
        discount: old.discount ?? item.discount,
        totalDiscount: (old.totalDiscount ?? 0) + (item.totalDiscount ?? 0),
        gstcodeId: old.gstcodeId ?? item.gstcodeId,
        netPriceINCTax: old.netPriceINCTax ?? item.netPriceINCTax,
        cgstPer: old.cgstPer ?? item.cgstPer,
        cgstAmount: (old.cgstAmount ?? 0) + (item.cgstAmount ?? 0),
        sgstPer: old.sgstPer ?? item.sgstPer,
        sgstAmount: (old.sgstAmount ?? 0) + (item.sgstAmount ?? 0),
        igstPer: old.igstPer ?? item.igstPer,
        igstAmount: (old.igstAmount ?? 0) + (item.igstAmount ?? 0),
        taxableAmount: (old.taxableAmount ?? 0) + (item.taxableAmount ?? 0),
        netAmount: (old.netAmount ?? 0) + (item.netAmount ?? 0),
        grossAmount: (old.grossAmount ?? 0) + (item.grossAmount ?? 0),
        itemImage: old.itemImage ?? item.itemImage,
      );
    }
    return merged;
  }

  static Map<String, String> _totalsFromItems(List<SaleOrderDetails> items) {
    double totalAmt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalNetAmount = 0;
    for (final item in items) {
      totalAmt += (item.price ?? 0) * (item.qty ?? 1);
      totalDiscount += item.totalDiscount ?? 0;
      totalCGST += item.cgstAmount ?? 0;
      totalSGST += item.sgstAmount ?? 0;
      totalIGST += item.igstAmount ?? 0;
      totalNetAmount += item.netAmount ?? 0;
    }
    return {
      'total': totalAmt.toStringAsFixed(2),
      'discountTotal': totalDiscount.toStringAsFixed(2),
      'cGstTotal': totalCGST.toStringAsFixed(2),
      'sGstTotal': totalSGST.toStringAsFixed(2),
      'iGstTotal': totalIGST.toStringAsFixed(2),
      'totalItem': items.length.toString(),
      'netTotal': totalNetAmount.toStringAsFixed(2),
    };
  }

  static List<SalesOrderCartModel> loadAll() {
    if (!GetStorageData.containKey(_storageKey)) {
      return [];
    }

    try {
      final raw = GetStorageData.readObject(_storageKey);
      if (raw is List) {
        return raw
            .map((item) => item is Map<String, dynamic>
                ? SalesOrderCartModel.fromJson(item)
                : SalesOrderCartModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ))
            .toList();
      }
      if (raw is Map) {
        return [
          SalesOrderCartModel.fromJson(Map<String, dynamic>.from(raw)),
        ];
      }
    } catch (_) {
      return [];
    }
    return [];
  }

  static SalesOrderCartModel? loadLatest() {
    final carts = loadAll();
    return carts.isEmpty ? null : carts.first;
  }

  static Future<void> removeCart(String cartId) async {
    final carts = loadAll()..removeWhere((cart) => cart.cartId == cartId);
    if (carts.isEmpty) {
      clear();
      return;
    }
    await GetStorageData.saveObject(
      _storageKey,
      carts.map((e) => e.toJson()).toList(),
    );
  }

  static Future<void> updateItemQty(
    String cartId,
    int itemIndex,
    double newQty,
  ) async {
    if (newQty <= 0) {
      await removeItem(cartId, itemIndex);
      return;
    }

    final carts = loadAll();
    final cartIndex = carts.indexWhere((cart) => cart.cartId == cartId);
    if (cartIndex == -1) return;

    final cart = carts[cartIndex];
    if (itemIndex < 0 || itemIndex >= cart.items.length) return;

    final items = List<SaleOrderDetails>.from(cart.items);
    final item = items[itemIndex];
    final oldQty = item.qty ?? 1;
    if (oldQty <= 0) return;

    final ratio = newQty / oldQty;
    items[itemIndex] = SaleOrderDetails(
      itemId: item.itemId,
      itemName: item.itemName,
      unit: item.unit,
      qty: newQty,
      price: item.price,
      discountPer: item.discountPer,
      discount: (item.discount ?? 0) * ratio,
      totalDiscount: (item.totalDiscount ?? 0) * ratio,
      gstcodeId: item.gstcodeId,
      netPriceINCTax: item.netPriceINCTax,
      cgstPer: item.cgstPer,
      cgstAmount: (item.cgstAmount ?? 0) * ratio,
      sgstPer: item.sgstPer,
      sgstAmount: (item.sgstAmount ?? 0) * ratio,
      igstPer: item.igstPer,
      igstAmount: (item.igstAmount ?? 0) * ratio,
      taxableAmount: (item.taxableAmount ?? 0) * ratio,
      netAmount: (item.netAmount ?? 0) * ratio,
      grossAmount: (item.grossAmount ?? 0) * ratio,
      itemImage: item.itemImage,
    );

    double totalAmt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalNetAmount = 0;
    for (final cartItem in items) {
      totalAmt += (cartItem.price ?? 0) * (cartItem.qty ?? 1);
      totalDiscount += cartItem.totalDiscount ?? 0;
      totalCGST += cartItem.cgstAmount ?? 0;
      totalSGST += cartItem.sgstAmount ?? 0;
      totalIGST += cartItem.igstAmount ?? 0;
      totalNetAmount += cartItem.netAmount ?? 0;
    }

    carts[cartIndex] = SalesOrderCartModel(
      cartId: cart.cartId,
      items: items,
      total: totalAmt.toStringAsFixed(2),
      discountTotal: totalDiscount.toStringAsFixed(2),
      cGstTotal: totalCGST.toStringAsFixed(2),
      sGstTotal: totalSGST.toStringAsFixed(2),
      iGstTotal: totalIGST.toStringAsFixed(2),
      totalItem: items.length.toString(),
      netTotal: totalNetAmount.toStringAsFixed(2),
      orderNo: cart.orderNo,
      customerId: cart.customerId,
      customerName: cart.customerName,
      savedAt: cart.savedAt,
    );

    await GetStorageData.saveObject(
      _storageKey,
      carts.map((e) => e.toJson()).toList(),
    );
  }

  static Future<void> removeItem(String cartId, int itemIndex) async {
    final carts = loadAll();
    final cartIndex = carts.indexWhere((cart) => cart.cartId == cartId);
    if (cartIndex == -1) return;

    final cart = carts[cartIndex];
    if (itemIndex < 0 || itemIndex >= cart.items.length) return;

    final items = List<SaleOrderDetails>.from(cart.items)..removeAt(itemIndex);
    if (items.isEmpty) {
      await removeCart(cartId);
      return;
    }

    double totalAmt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalNetAmount = 0;
    for (final item in items) {
      totalAmt += (item.price ?? 0) * (item.qty ?? 1);
      totalDiscount += item.totalDiscount ?? 0;
      totalCGST += item.cgstAmount ?? 0;
      totalSGST += item.sgstAmount ?? 0;
      totalIGST += item.igstAmount ?? 0;
      totalNetAmount += item.netAmount ?? 0;
    }

    carts[cartIndex] = SalesOrderCartModel(
      cartId: cart.cartId,
      items: items,
      total: totalAmt.toStringAsFixed(2),
      discountTotal: totalDiscount.toStringAsFixed(2),
      cGstTotal: totalCGST.toStringAsFixed(2),
      sGstTotal: totalSGST.toStringAsFixed(2),
      iGstTotal: totalIGST.toStringAsFixed(2),
      totalItem: items.length.toString(),
      netTotal: totalNetAmount.toStringAsFixed(2),
      orderNo: cart.orderNo,
      customerId: cart.customerId,
      customerName: cart.customerName,
      savedAt: cart.savedAt,
    );

    await GetStorageData.saveObject(
      _storageKey,
      carts.map((e) => e.toJson()).toList(),
    );
  }

  static void clear() {
    if (GetStorageData.containKey(_storageKey)) {
      GetStorageData.removeData(_storageKey);
    }
  }

  static int itemCount() => loadAll().length;
}
