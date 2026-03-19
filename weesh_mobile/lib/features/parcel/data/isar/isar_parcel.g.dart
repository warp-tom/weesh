// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_parcel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarParcelCollection on Isar {
  IsarCollection<IsarParcel> get isarParcels => this.collection();
}

const IsarParcelSchema = CollectionSchema(
  name: r'IsarParcel',
  id: 3005704919829265744,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dropLat': PropertySchema(
      id: 1,
      name: r'dropLat',
      type: IsarType.double,
    ),
    r'dropLng': PropertySchema(
      id: 2,
      name: r'dropLng',
      type: IsarType.double,
    ),
    r'parcelDescription': PropertySchema(
      id: 3,
      name: r'parcelDescription',
      type: IsarType.string,
    ),
    r'pickupLat': PropertySchema(
      id: 4,
      name: r'pickupLat',
      type: IsarType.double,
    ),
    r'pickupLng': PropertySchema(
      id: 5,
      name: r'pickupLng',
      type: IsarType.double,
    ),
    r'receiverName': PropertySchema(
      id: 6,
      name: r'receiverName',
      type: IsarType.string,
    ),
    r'receiverPhone': PropertySchema(
      id: 7,
      name: r'receiverPhone',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 8,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _IsarParcelsyncStatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 11,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarParcelEstimateSize,
  serialize: _isarParcelSerialize,
  deserialize: _isarParcelDeserialize,
  deserializeProp: _isarParcelDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarParcelGetId,
  getLinks: _isarParcelGetLinks,
  attach: _isarParcelAttach,
  version: '3.1.0+1',
);

int _isarParcelEstimateSize(
  IsarParcel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.parcelDescription.length * 3;
  bytesCount += 3 + object.receiverName.length * 3;
  bytesCount += 3 + object.receiverPhone.length * 3;
  bytesCount += 3 + object.remoteId.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _isarParcelSerialize(
  IsarParcel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDouble(offsets[1], object.dropLat);
  writer.writeDouble(offsets[2], object.dropLng);
  writer.writeString(offsets[3], object.parcelDescription);
  writer.writeDouble(offsets[4], object.pickupLat);
  writer.writeDouble(offsets[5], object.pickupLng);
  writer.writeString(offsets[6], object.receiverName);
  writer.writeString(offsets[7], object.receiverPhone);
  writer.writeString(offsets[8], object.remoteId);
  writer.writeString(offsets[9], object.syncStatus.name);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeString(offsets[11], object.userId);
}

IsarParcel _isarParcelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarParcel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dropLat = reader.readDouble(offsets[1]);
  object.dropLng = reader.readDouble(offsets[2]);
  object.id = id;
  object.parcelDescription = reader.readString(offsets[3]);
  object.pickupLat = reader.readDouble(offsets[4]);
  object.pickupLng = reader.readDouble(offsets[5]);
  object.receiverName = reader.readString(offsets[6]);
  object.receiverPhone = reader.readString(offsets[7]);
  object.remoteId = reader.readString(offsets[8]);
  object.syncStatus =
      _IsarParcelsyncStatusValueEnumMap[reader.readStringOrNull(offsets[9])] ??
          SyncStatus.pending;
  object.updatedAt = reader.readDateTime(offsets[10]);
  object.userId = reader.readString(offsets[11]);
  return object;
}

P _isarParcelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (_IsarParcelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.pending) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IsarParcelsyncStatusEnumValueMap = {
  r'pending': r'pending',
  r'synced': r'synced',
  r'failed': r'failed',
};
const _IsarParcelsyncStatusValueEnumMap = {
  r'pending': SyncStatus.pending,
  r'synced': SyncStatus.synced,
  r'failed': SyncStatus.failed,
};

Id _isarParcelGetId(IsarParcel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarParcelGetLinks(IsarParcel object) {
  return [];
}

void _isarParcelAttach(IsarCollection<dynamic> col, Id id, IsarParcel object) {
  object.id = id;
}

extension IsarParcelQueryWhereSort
    on QueryBuilder<IsarParcel, IsarParcel, QWhere> {
  QueryBuilder<IsarParcel, IsarParcel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarParcelQueryWhere
    on QueryBuilder<IsarParcel, IsarParcel, QWhereClause> {
  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> remoteIdEqualTo(
      String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> remoteIdNotEqualTo(
      String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterWhereClause> userIdNotEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarParcelQueryFilter
    on QueryBuilder<IsarParcel, IsarParcel, QFilterCondition> {
  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dropLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      dropLatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dropLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dropLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dropLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLngEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dropLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      dropLngGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dropLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLngLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dropLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> dropLngBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dropLng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parcelDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parcelDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parcelDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parcelDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      parcelDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parcelDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pickupLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      pickupLatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pickupLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pickupLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pickupLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLngEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pickupLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      pickupLngGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pickupLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLngLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pickupLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> pickupLngBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pickupLng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiverName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiverName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiverName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiverPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiverPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      receiverPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiverPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> remoteIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> syncStatusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension IsarParcelQueryObject
    on QueryBuilder<IsarParcel, IsarParcel, QFilterCondition> {}

extension IsarParcelQueryLinks
    on QueryBuilder<IsarParcel, IsarParcel, QFilterCondition> {}

extension IsarParcelQuerySortBy
    on QueryBuilder<IsarParcel, IsarParcel, QSortBy> {
  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByDropLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLat', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByDropLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLat', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByDropLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLng', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByDropLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLng', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByParcelDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelDescription', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy>
      sortByParcelDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelDescription', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByPickupLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLat', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByPickupLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLat', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByPickupLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLng', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByPickupLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLng', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByReceiverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByReceiverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByReceiverPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverPhone', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByReceiverPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverPhone', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarParcelQuerySortThenBy
    on QueryBuilder<IsarParcel, IsarParcel, QSortThenBy> {
  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByDropLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLat', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByDropLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLat', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByDropLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLng', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByDropLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dropLng', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByParcelDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelDescription', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy>
      thenByParcelDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelDescription', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByPickupLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLat', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByPickupLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLat', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByPickupLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLng', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByPickupLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pickupLng', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByReceiverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByReceiverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverName', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByReceiverPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverPhone', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByReceiverPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverPhone', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarParcelQueryWhereDistinct
    on QueryBuilder<IsarParcel, IsarParcel, QDistinct> {
  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByDropLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dropLat');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByDropLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dropLng');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByParcelDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parcelDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByPickupLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pickupLat');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByPickupLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pickupLng');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByReceiverName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiverName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByReceiverPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiverPhone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByRemoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctBySyncStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<IsarParcel, IsarParcel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarParcelQueryProperty
    on QueryBuilder<IsarParcel, IsarParcel, QQueryProperty> {
  QueryBuilder<IsarParcel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarParcel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarParcel, double, QQueryOperations> dropLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dropLat');
    });
  }

  QueryBuilder<IsarParcel, double, QQueryOperations> dropLngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dropLng');
    });
  }

  QueryBuilder<IsarParcel, String, QQueryOperations>
      parcelDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parcelDescription');
    });
  }

  QueryBuilder<IsarParcel, double, QQueryOperations> pickupLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pickupLat');
    });
  }

  QueryBuilder<IsarParcel, double, QQueryOperations> pickupLngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pickupLng');
    });
  }

  QueryBuilder<IsarParcel, String, QQueryOperations> receiverNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiverName');
    });
  }

  QueryBuilder<IsarParcel, String, QQueryOperations> receiverPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiverPhone');
    });
  }

  QueryBuilder<IsarParcel, String, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<IsarParcel, SyncStatus, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<IsarParcel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<IsarParcel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
