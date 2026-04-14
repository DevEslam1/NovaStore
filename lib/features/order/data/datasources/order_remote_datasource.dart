import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(String userId);
  Future<void> createOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createOrder(OrderModel order) async {
    try {
      await firestore.collection('orders').add(order.toJson());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
