import 'package:hive/hive.dart';

import '../../../domain/entities/booking.dart';

// Booking Adapter
class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 2;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Booking(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: BookingType.values[fields[2] as int],
      status: BookingStatus.values[fields[3] as int],
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      checkInDate: DateTime.fromMillisecondsSinceEpoch(fields[6] as int),
      checkOutDate: DateTime.fromMillisecondsSinceEpoch(fields[7] as int),
      guestCount: fields[8] as int,
      totalAmount: fields[9] as double,
      currency: fields[10] as String,
      paymentInfo: fields[11] as PaymentInfo,
      travelers: (fields[12] as List).cast<Traveler>(),
      contactPerson: fields[13] as ContactPerson,
      item: fields[14] as BookingItem,
      specialRequests: (fields[15] as List?)?.cast<String>() ?? [],
      metadata: (fields[16] as Map?)?.cast<String, dynamic>() ?? {},
      updates: (fields[17] as List?)?.cast<BookingUpdate>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type.index)
      ..writeByte(3)
      ..write(obj.status.index)
      ..writeByte(4)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(5)
      ..write(obj.updatedAt.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.checkInDate.millisecondsSinceEpoch)
      ..writeByte(7)
      ..write(obj.checkOutDate.millisecondsSinceEpoch)
      ..writeByte(8)
      ..write(obj.guestCount)
      ..writeByte(9)
      ..write(obj.totalAmount)
      ..writeByte(10)
      ..write(obj.currency)
      ..writeByte(11)
      ..write(obj.paymentInfo)
      ..writeByte(12)
      ..write(obj.travelers)
      ..writeByte(13)
      ..write(obj.contactPerson)
      ..writeByte(14)
      ..write(obj.item)
      ..writeByte(15)
      ..write(obj.specialRequests)
      ..writeByte(16)
      ..write(obj.metadata)
      ..writeByte(17)
      ..write(obj.updates);
  }
}

// BookingType Adapter
class BookingTypeAdapter extends TypeAdapter<BookingType> {
  @override
  final int typeId = 3;

  @override
  BookingType read(BinaryReader reader) {
    return BookingType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, BookingType obj) {
    writer.writeByte(obj.index);
  }
}

// BookingStatus Adapter
class BookingStatusAdapter extends TypeAdapter<BookingStatus> {
  @override
  final int typeId = 4;

  @override
  BookingStatus read(BinaryReader reader) {
    return BookingStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, BookingStatus obj) {
    writer.writeByte(obj.index);
  }
}

// BookingItem Adapter
class BookingItemAdapter extends TypeAdapter<BookingItem> {
  @override
  final int typeId = 5;

  @override
  BookingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return BookingItem(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      images: (fields[3] as List).cast<String>(),
      details: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.details);
  }
}

// Traveler Adapter
class TravelerAdapter extends TypeAdapter<Traveler> {
  @override
  final int typeId = 6;

  @override
  Traveler read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Traveler(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      phoneNumber: fields[4] as String,
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      nationality: fields[6] as String,
      passportNumber: fields[7] as String,
      passportExpiry: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
      specialRequests: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Traveler obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.dateOfBirth.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.nationality)
      ..writeByte(7)
      ..write(obj.passportNumber)
      ..writeByte(8)
      ..write(obj.passportExpiry.millisecondsSinceEpoch)
      ..writeByte(9)
      ..write(obj.specialRequests);
  }
}

// ContactPerson Adapter
class ContactPersonAdapter extends TypeAdapter<ContactPerson> {
  @override
  final int typeId = 7;

  @override
  ContactPerson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ContactPerson(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String,
      country: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactPerson obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.country);
  }
}

// PaymentInfo Adapter
class PaymentInfoAdapter extends TypeAdapter<PaymentInfo> {
  @override
  final int typeId = 8;

  @override
  PaymentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return PaymentInfo(
      id: fields[0] as String,
      method: fields[1] as String,
      status: fields[2] as String,
      amount: fields[3] as double,
      currency: fields[4] as String,
      paidAt: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      transactionId: fields[6] as String?,
      details: (fields[7] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  @override
  void write(BinaryWriter writer, PaymentInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.paidAt.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.transactionId)
      ..writeByte(7)
      ..write(obj.details);
  }
}

// BookingUpdate Adapter
class BookingUpdateAdapter extends TypeAdapter<BookingUpdate> {
  @override
  final int typeId = 9;

  @override
  BookingUpdate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return BookingUpdate(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
      type: BookingUpdateType.values[fields[4] as int],
      metadata: (fields[5] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  @override
  void write(BinaryWriter writer, BookingUpdate obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.timestamp.millisecondsSinceEpoch)
      ..writeByte(4)
      ..write(obj.type.index)
      ..writeByte(5)
      ..write(obj.metadata);
  }
}

// BookingUpdateType Adapter
class BookingUpdateTypeAdapter extends TypeAdapter<BookingUpdateType> {
  @override
  final int typeId = 10;

  @override
  BookingUpdateType read(BinaryReader reader) {
    return BookingUpdateType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, BookingUpdateType obj) {
    writer.writeByte(obj.index);
  }
}
