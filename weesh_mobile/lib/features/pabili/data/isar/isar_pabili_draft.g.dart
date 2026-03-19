// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_pabili_draft.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarPabiliDraftCollection on Isar {
  IsarCollection<IsarPabiliDraft> get isarPabiliDrafts => this.collection();
}

const IsarPabiliDraftSchema = CollectionSchema(
  name: r'IsarPabiliDraft',
  id: 1498541334467010795,
  properties: {
    r'documentJson': PropertySchema(
      id: 0,
      name: r'documentJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 1,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarPabiliDraftEstimateSize,
  serialize: _isarPabiliDraftSerialize,
  deserialize: _isarPabiliDraftDeserialize,
  deserializeProp: _isarPabiliDraftDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarPabiliDraftGetId,
  getLinks: _isarPabiliDraftGetLinks,
  attach: _isarPabiliDraftAttach,
  version: '3.1.0+1',
);

int _isarPabiliDraftEstimateSize(
  IsarPabiliDraft object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.documentJson.length * 3;
  return bytesCount;
}

void _isarPabiliDraftSerialize(
  IsarPabiliDraft object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.documentJson);
  writer.writeDateTime(offsets[1], object.updatedAt);
}

IsarPabiliDraft _isarPabiliDraftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarPabiliDraft();
  object.documentJson = reader.readString(offsets[0]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _isarPabiliDraftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarPabiliDraftGetId(IsarPabiliDraft object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarPabiliDraftGetLinks(IsarPabiliDraft object) {
  return [];
}

void _isarPabiliDraftAttach(
    IsarCollection<dynamic> col, Id id, IsarPabiliDraft object) {
  object.id = id;
}

extension IsarPabiliDraftQueryWhereSort
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QWhere> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarPabiliDraftQueryWhere
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QWhereClause> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterWhereClause> idBetween(
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
}

extension IsarPabiliDraftQueryFilter
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QFilterCondition> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      documentJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterFilterCondition>
      updatedAtBetween(
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
}

extension IsarPabiliDraftQueryObject
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QFilterCondition> {}

extension IsarPabiliDraftQueryLinks
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QFilterCondition> {}

extension IsarPabiliDraftQuerySortBy
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QSortBy> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      sortByDocumentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.asc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      sortByDocumentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.desc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarPabiliDraftQuerySortThenBy
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QSortThenBy> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      thenByDocumentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.asc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      thenByDocumentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.desc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarPabiliDraftQueryWhereDistinct
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QDistinct> {
  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QDistinct>
      distinctByDocumentJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarPabiliDraftQueryProperty
    on QueryBuilder<IsarPabiliDraft, IsarPabiliDraft, QQueryProperty> {
  QueryBuilder<IsarPabiliDraft, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarPabiliDraft, String, QQueryOperations>
      documentJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentJson');
    });
  }

  QueryBuilder<IsarPabiliDraft, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
