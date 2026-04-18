import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newstore/core/error/failures.dart';
import 'package:newstore/features/profile/domain/entities/address_entity.dart';
import 'package:newstore/features/profile/domain/repositories/address_repository.dart';
import 'package:newstore/features/profile/presentation/bloc/address_bloc.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  late AddressBloc addressBloc;
  late MockAddressRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(AddressEntity(
      id: '',
      label: '',
      fullName: '',
      phone: '',
      street: '',
      city: '',
      state: '',
      zipCode: '',
      country: '',
      isDefault: false,
    ));
  });

  setUp(() {
    mockRepository = MockAddressRepository();
    addressBloc = AddressBloc(repository: mockRepository);
  });

  tearDown(() {
    addressBloc.close();
  });

  final tAddress = AddressEntity(
    id: '1',
    label: 'Home',
    fullName: 'Eslam Mahmoud',
    phone: '123456789',
    street: '123 Street',
    city: 'Cairo',
    state: 'Cairo',
    zipCode: '12345',
    country: 'Egypt',
    isDefault: true,
  );

  final tAddressesList = [tAddress];

  group('LoadAddresses', () {
    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressLoaded] when successful',
      build: () {
        when(() => mockRepository.getAddresses())
            .thenAnswer((_) async => Right(tAddressesList));
        return addressBloc;
      },
      act: (bloc) => bloc.add(LoadAddresses()),
      expect: () => [
        AddressLoading(),
        AddressLoaded(tAddressesList),
      ],
      verify: (_) {
        verify(() => mockRepository.getAddresses()).called(1);
      },
    );

    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressError] when unsuccessful',
      build: () {
        when(() => mockRepository.getAddresses())
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return addressBloc;
      },
      act: (bloc) => bloc.add(LoadAddresses()),
      expect: () => [
        AddressLoading(),
        const AddressError('Server Error'),
      ],
    );
  });

  group('AddAddress', () {
    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading] and triggers LoadAddresses when successful',
      build: () {
        when(() => mockRepository.addAddress(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.getAddresses())
            .thenAnswer((_) async => Right(tAddressesList));
        return addressBloc;
      },
      act: (bloc) => bloc.add(AddAddress(tAddress)),
      expect: () => [
        AddressLoading(),
        AddressLoading(), // From LoadAddresses re-add
        AddressLoaded(tAddressesList),
      ],
    );
  });
}
