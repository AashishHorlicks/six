import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseItem {
  final String id;
  DatabaseItem(this.id);
}

class DatabaseService<T> {
  String collection;
  final Firestore _db = Firestore.instance;
  final T Function(String, Map<String, dynamic>) fromDS;
  final Map<String, dynamic> Function(T) toMap;
  DatabaseService(this.collection, {this.fromDS, this.toMap});

  Firestore get db => _db;

  Future<T> getSingle(String id) async {
    var snap = await _db.collection(collection).document(id).get();
    if (!snap.exists) return null;
    return fromDS(snap.documentID, snap.data);
  }

  Stream<T> streamSingle(String id) {
    return _db
        .collection(collection)
        .document(id)
        .snapshots()
        .map((snap) => snap.exists ? fromDS(snap.documentID, snap.data) : null);
  }

  Stream<List<T>> streamList() {
    var ref = _db.collection(collection);
    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<List<T>> getQueryList(
      {List<OrderBy> orderBy,
      List<QueryArgs> args,
      int limit,
      dynamic startAfter}) async {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    if (args != null) {
      for (final arg in args) {
        if (arg is QueryArgsV2) {
          if (ref == null)
            ref = collref.where(
              arg.key,
              isEqualTo: arg.isEqualTo,
              isGreaterThan: arg.isGreaterThan,
              isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
              isLessThan: arg.isLessThan,
              isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
              isNull: arg.isNull,
              arrayContains: arg.arrayContains,
              arrayContainsAny: arg.arrayContainsAny,
              whereIn: arg.whereIn,
            );
          else
            ref = ref.where(
              arg.key,
              isEqualTo: arg.isEqualTo,
              isGreaterThan: arg.isGreaterThan,
              isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
              isLessThan: arg.isLessThan,
              isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
              isNull: arg.isNull,
              arrayContains: arg.arrayContains,
              arrayContainsAny: arg.arrayContainsAny,
              whereIn: arg.whereIn,
            );
          ;
        } else {
          if (ref == null)
            ref = collref.where(arg.key, isEqualTo: arg.value);
          else
            ref = ref.where(arg.key, isEqualTo: arg.value);
        }
      }
    }
    if (orderBy != null) {
      orderBy.forEach((order) {
        if (ref == null)
          ref = collref.orderBy(order.field, descending: order.descending);
        else
          ref = ref.orderBy(order.field, descending: order.descending);
      });
    }
    if (limit != null) {
      if (ref == null)
        ref = collref.limit(limit);
      else
        ref = ref.limit(limit);
    }
    if (startAfter != null && orderBy != null) {
      ref = ref.startAfter([startAfter]);
    }
    QuerySnapshot query;
    if (ref != null)
      query = await ref.getDocuments();
    else
      query = await collref.getDocuments();

    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamQueryList(
      {List<OrderBy> orderBy,
      List<QueryArgs> args,
      int limit,
      dynamic startAfter}) {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    if (orderBy != null) {
      orderBy.forEach((order) {
        if (ref == null)
          ref = collref.orderBy(order.field, descending: order.descending);
        else
          ref = ref.orderBy(order.field, descending: order.descending);
      });
    }
    if (args != null) {
      for (final arg in args) {
        if (arg is QueryArgsV2) {
          if (ref == null)
            ref = collref.where(
              arg.key,
              isEqualTo: arg.isEqualTo,
              isGreaterThan: arg.isGreaterThan,
              isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
              isLessThan: arg.isLessThan,
              isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
              isNull: arg.isNull,
              arrayContains: arg.arrayContains,
              arrayContainsAny: arg.arrayContainsAny,
              whereIn: arg.whereIn,
            );
          else
            ref = ref.where(
              arg.key,
              isEqualTo: arg.isEqualTo,
              isGreaterThan: arg.isGreaterThan,
              isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
              isLessThan: arg.isLessThan,
              isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
              isNull: arg.isNull,
              arrayContains: arg.arrayContains,
              arrayContainsAny: arg.arrayContainsAny,
              whereIn: arg.whereIn,
            );
        } else {
          if (ref == null)
            ref = collref.where(arg.key, isEqualTo: arg.value);
          else
            ref = ref.where(arg.key, isEqualTo: arg.value);
        }
      }
    }
    if (limit != null) {
      if (ref == null)
        ref = collref.limit(limit);
      else
        ref = ref.limit(limit);
    }
    if (startAfter != null && orderBy != null) {
      ref = ref.startAfter([startAfter]);
    }
    if (ref != null)
      return ref.snapshots().map((snap) => snap.documents
          .map((doc) => fromDS(doc.documentID, doc.data))
          .toList());
    else
      return collref.snapshots().map((snap) => snap.documents
          .map((doc) => fromDS(doc.documentID, doc.data))
          .toList());
  }

  Future<List<T>> getListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) async {
    var ref = _db.collection(collection).orderBy(field);
    for (final arg in args) {
      if (arg is QueryArgsV2) {
        ref = ref.where(
          arg.key,
          isEqualTo: arg.isEqualTo,
          isGreaterThan: arg.isGreaterThan,
          isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
          isLessThan: arg.isLessThan,
          isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
          isNull: arg.isNull,
          arrayContains: arg.arrayContains,
          arrayContainsAny: arg.arrayContainsAny,
          whereIn: arg.whereIn,
        );
      } else {
        ref = ref.where(arg.key, isEqualTo: arg.value);
      }
    }
    QuerySnapshot query = await ref.startAt([from]).endAt([to]).getDocuments();
    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) {
    var ref = _db.collection(collection).orderBy(field, descending: true);
    for (final arg in args) {
      if (arg is QueryArgsV2) {
        ref = ref.where(
          arg.key,
          isEqualTo: arg.isEqualTo,
          isGreaterThan: arg.isGreaterThan,
          isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
          isLessThan: arg.isLessThan,
          isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
          isNull: arg.isNull,
          arrayContains: arg.arrayContains,
          arrayContainsAny: arg.arrayContainsAny,
          whereIn: arg.whereIn,
        );
      } else {
        ref = ref.where(arg.key, isEqualTo: arg.value);
      }
    }
    var query = ref.startAfter([to]).endAt([from]).snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<dynamic> createItem(T item, {String id}) {
    if (id != null) {
      return _db.collection(collection).document(id).setData(toMap(item));
    } else {
      return _db.collection(collection).add(toMap(item));
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> data) {
    return _db.collection(collection).document(id).updateData(data);
  }

  Future<void> removeItem(String id) {
    return _db.collection(collection).document(id).delete();
  }
}

class QueryArgs {
  final dynamic key;
  final dynamic value;

  QueryArgs(this.key, this.value);
}

class QueryArgsV2 extends QueryArgs {
  final dynamic key;
  final dynamic isEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic arrayContains;
  final List<dynamic> arrayContainsAny;
  final List<dynamic> whereIn;
  final bool isNull;

  QueryArgsV2(this.key,
      {this.isEqualTo,
      this.isLessThan,
      this.isLessThanOrEqualTo,
      this.isGreaterThan,
      this.arrayContains,
      this.arrayContainsAny,
      this.whereIn,
      this.isNull,
      this.isGreaterThanOrEqualTo})
      : super(key, isEqualTo);
}

class OrderBy {
  final String field;
  final bool descending;

  OrderBy(this.field, {this.descending = false});
}
