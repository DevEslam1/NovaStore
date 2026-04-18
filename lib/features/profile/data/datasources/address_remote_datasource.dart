import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AddressRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String get _uid => auth.currentUser?.uid ?? (throw Exception('User not logged in'));

  CollectionReference get _addressCollection =>
      firestore.collection('users').doc(_uid).collection('addresses');

  @override
  Future<List<AddressModel>> getAddresses() async {
    final snapshot = await _addressCollection.get();
    return snapshot.docs
        .map((doc) => AddressModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    // If this is the first address, or isDefault is true, handle it
    final addresses = await getAddresses();
    final isFirst = addresses.isEmpty;

    final data = address.toJson();
    if (isFirst) {
      data['isDefault'] = true;
    }

    await _addressCollection.add(data);
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    await _addressCollection.doc(address.id).update(address.toJson());
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await _addressCollection.doc(addressId).delete();
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    final batch = firestore.batch();
    final snapshot = await _addressCollection.get();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == addressId});
    }

    await batch.commit();
  }
}
