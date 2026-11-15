/// The three kinds of post a broker can share.
enum PostType {
  /// A property available for sale or rent.
  listing,

  /// A client looking for a property.
  request,

  /// A viewing to arrange or share.
  viewing;

  static PostType? fromJson(String? value) => switch (value) {
        'listing' => listing,
        'request' => request,
        'viewing' => viewing,
        _ => null,
      };
}
