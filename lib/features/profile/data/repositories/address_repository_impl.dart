import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/address_remote_datasource.dart';
import '../models/address_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAddresses = await remoteDataSource.getAddresses();
        return Right(remoteAddresses);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress(AddressEntity address) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addAddress(AddressModel.fromEntity(address));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(AddressEntity address) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateAddress(AddressModel.fromEntity(address));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAddress(addressId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String addressId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.setDefaultAddress(addressId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }
}
