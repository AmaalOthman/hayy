import 'package:equatable/equatable.dart';

import 'community.dart';

/// Browse filters. Null means "any".
class CommunityFilter extends Equatable {
  const CommunityFilter({this.query = '', this.transaction, this.use});

  /// Matched against the neighbourhood name.
  final String query;
  final TransactionType? transaction;
  final PropertyUse? use;

  CommunityFilter copyWith({
    String? query,
    TransactionType? Function()? transaction,
    PropertyUse? Function()? use,
  }) =>
      CommunityFilter(
        query: query ?? this.query,
        transaction: transaction != null ? transaction() : this.transaction,
        use: use != null ? use() : this.use,
      );

  Map<String, dynamic> toQuery() => {
        if (query.trim().isNotEmpty) 'q': query.trim(),
        if (transaction != null) 'transaction': transaction!.toJson(),
        if (use != null) 'use': use!.toJson(),
      };

  @override
  List<Object?> get props => [query, transaction, use];
}
