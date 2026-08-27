import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';

class SubCategoryDetailArgs {
  final SubCategoryListData subCategory;
  final List<ItemListData> items;

  const SubCategoryDetailArgs({
    required this.subCategory,
    required this.items,
  });
}
