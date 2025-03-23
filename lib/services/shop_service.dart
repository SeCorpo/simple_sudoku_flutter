import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/custom_exceptions.dart';
import '../core/utils/logger.dart';

class ShopService {
  static const String _fileName = "user_progress.json";

  /// Get the file object for the shop data
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/simple_sudoku";
    final folder = Directory(path);

    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    return File("$path/$_fileName");
  }

  /// Read and return the parsed user progress
  Future<Map<String, dynamic>> _readData() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode({"points": 0, "purchases": {}}));
      }
      final content = await file.readAsString();
      return jsonDecode(content);
    } catch (e) {
      Logger.e("Error reading shop data: $e");
      throw ShopReadException();
    }
  }

  /// Write data to the shop file
  Future<void> _writeData(Map<String, dynamic> data) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      Logger.e("Error writing shop data: $e");
      throw ShopWriteException();
    }
  }

  /// Get current points
  Future<int> getPoints() async {
    final data = await _readData();
    return data['points'] ?? 0;
  }

  /// Buy an item and increment its count
  Future<int> buyItem(String itemKey, int cost) async {
    try {
      final data = await _readData();
      final currentPoints = data['points'] ?? 0;

      if (currentPoints < cost) {
        throw NotEnoughPointsException();
      }

      data['points'] = currentPoints - cost;

      // Increase the count of this item
      final currentCount = (data['purchases'][itemKey] ?? 0) as int;
      data['purchases'][itemKey] = currentCount + 1;

      await _writeData(data);
      Logger.i("Bought $itemKey (x${data['purchases'][itemKey]}). Remaining points: ${data['points']}");

      return data['points'];
    } catch (e) {
      Logger.e("Error buying item: $e");
      if (e is NotEnoughPointsException) rethrow;
      throw ShopPurchaseException();
    }
  }

  /// Consume (use) one unit of a purchased item
  Future<void> consumeItem(String itemKey) async {
    try {
      final data = await _readData();
      int count = (data['purchases'][itemKey] ?? 0) as int;

      if (count <= 0) {
        Logger.w("Attempted to consume item '$itemKey' with 0 count.");
        throw NotEnoughItemsException();
      }

      data['purchases'][itemKey] = count - 1;
      await _writeData(data);

      Logger.i("Consumed one '$itemKey'. Remaining: ${data['purchases'][itemKey]}");
    } catch (e) {
      Logger.e("Error consuming item '$itemKey': $e");
      if (e is NotEnoughItemsException) rethrow;
      throw ShopConsumeException();
    }
  }

  /// Get item count instead of boolean
  Future<int> getItemCount(String itemKey) async {
    final data = await _readData();
    return (data['purchases'][itemKey] ?? 0) as int;
  }

  Future<Map<String, int>> getAllItemCounts() async {
    final data = await _readData();
    final purchases = data['purchases'] as Map<String, dynamic>;
    return purchases.map((key, value) => MapEntry(key, (value as int)));
  }


  /// Reset all purchases and points
  Future<void> resetShopProgress() async {
    try {
      final data = {"points": 0, "purchases": {}};
      await _writeData(data);
      Logger.i("Shop progress reset.");
    } catch (e) {
      Logger.e("Error resetting shop progress: $e");
      throw ShopResetException();
    }
  }
}
