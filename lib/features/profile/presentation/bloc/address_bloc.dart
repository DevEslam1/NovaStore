import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';

// Events
abstract class AddressEvent extends Equatable {
  const AddressEvent();
  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final AddressEntity address;
  const AddAddress(this.address);
  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final AddressEntity address;
  const UpdateAddress(this.address);
  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends AddressEvent {
  final String addressId;
  const DeleteAddress(this.addressId);
  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends AddressEvent {
  final String addressId;
  const SetDefaultAddress(this.addressId);
  @override
  List<Object?> get props => [addressId];
}

// States
abstract class AddressState extends Equatable {
  const AddressState();
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}
class AddressLoading extends AddressState {}
class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;
  const AddressLoaded(this.addresses);
  @override
  List<Object?> get props => [addresses];
}
class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository repository;

  AddressBloc({required this.repository}) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  Future<void> _onLoadAddresses(LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await repository.getAddresses();
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onAddAddress(AddAddress event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await repository.addAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  Future<void> _onUpdateAddress(UpdateAddress event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await repository.updateAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  Future<void> _onDeleteAddress(DeleteAddress event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await repository.deleteAddress(event.addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  Future<void> _onSetDefaultAddress(SetDefaultAddress event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await repository.setDefaultAddress(event.addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }
}
