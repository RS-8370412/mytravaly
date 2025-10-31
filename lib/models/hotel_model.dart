class Hotel {
  final String propertyCode;
  final String propertyName;
  final PropertyImage propertyImage;
  final String propertytype;
  final int propertyStar;
  final PropertyAddress propertyAddress;
  final PropertyPoliciesAndAmenities? propertyPoliciesAndAmenities;
  final String roomName;
  final int numberOfAdults;
  final Price markedPrice;
  final Price propertyMinPrice;
  final Price propertyMaxPrice;
  final List<AvailableDeal> availableDeals;
  final bool isFavorite;
  final GoogleReview? googleReview;

  Hotel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyImage,
    required this.propertytype,
    required this.propertyStar,
    required this.propertyAddress,
    this.propertyPoliciesAndAmenities,
    required this.roomName,
    required this.numberOfAdults,
    required this.markedPrice,
    required this.propertyMinPrice,
    required this.propertyMaxPrice,
    required this.availableDeals,
    required this.isFavorite,
    this.googleReview,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      propertyCode: json['propertyCode'] ?? '',
      propertyName: json['propertyName'] ?? '',
      propertyImage: PropertyImage.fromJson(json['propertyImage'] ?? {}),
      propertytype: json['propertytype'] ?? '',
      propertyStar: json['propertyStar'] ?? 0,
      propertyAddress: PropertyAddress.fromJson(json['propertyAddress'] ?? {}),
      propertyPoliciesAndAmenities: json['propertyPoliciesAndAmmenities'] != null &&
              json['propertyPoliciesAndAmmenities']['present'] == true
          ? PropertyPoliciesAndAmenities.fromJson(json['propertyPoliciesAndAmmenities']['data'] ?? {})
          : null,
      roomName: json['roomName'] ?? '',
      numberOfAdults: json['numberOfAdults'] ?? 0,
      markedPrice: Price.fromJson(json['markedPrice'] ?? {}),
      propertyMinPrice: Price.fromJson(json['propertyMinPrice'] ?? {}),
      propertyMaxPrice: Price.fromJson(json['propertyMaxPrice'] ?? {}),
      availableDeals: (json['availableDeals'] as List<dynamic>?)
              ?.map((e) => AvailableDeal.fromJson(e))
              .toList() ??
          [],
      isFavorite: json['isFavorite'] ?? false,
      googleReview: json['googleReview'] != null &&
              json['googleReview']['reviewPresent'] == true
          ? GoogleReview.fromJson(json['googleReview']['data'] ?? {})
          : null,
    );
  }
}

class PropertyImage {
  final String fullUrl;
  final String location;
  final String imageName;

  PropertyImage({
    required this.fullUrl,
    required this.location,
    required this.imageName,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      fullUrl: json['fullUrl'] ?? '',
      location: json['location'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }
}

class PropertyAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String mapAddress;
  final double latitude;
  final double longitude;

  PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      mapAddress: json['mapAddress'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PropertyPoliciesAndAmenities {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final String damagePolicy;
  final String propertyRestriction;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;

  PropertyPoliciesAndAmenities({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
  });

  factory PropertyPoliciesAndAmenities.fromJson(Map<String, dynamic> json) {
    return PropertyPoliciesAndAmenities(
      cancelPolicy: json['cancelPolicy'] ?? '',
      refundPolicy: json['refundPolicy'] ?? '',
      childPolicy: json['childPolicy'] ?? '',
      damagePolicy: json['damagePolicy'] ?? '',
      propertyRestriction: json['propertyRestriction'] ?? '',
      petsAllowed: json['petsAllowed'] ?? false,
      coupleFriendly: json['coupleFriendly'] ?? false,
      suitableForChildren: json['suitableForChildren'] ?? false,
      bachularsAllowed: json['bachularsAllowed'] ?? false,
      freeWifi: json['freeWifi'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
      payAtHotel: json['payAtHotel'] ?? false,
      payNow: json['payNow'] ?? false,
    );
  }
}

class Price {
  final double amount;
  final String displayAmount;
  final String currencyAmount;
  final String currencySymbol;

  Price({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      displayAmount: json['displayAmount'] ?? '',
      currencyAmount: json['currencyAmount'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
    );
  }
}

class AvailableDeal {
  final String headerName;
  final String websiteUrl;
  final String dealType;
  final Price price;

  AvailableDeal({
    required this.headerName,
    required this.websiteUrl,
    required this.dealType,
    required this.price,
  });

  factory AvailableDeal.fromJson(Map<String, dynamic> json) {
    return AvailableDeal(
      headerName: json['headerName'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      dealType: json['dealType'] ?? '',
      price: Price.fromJson(json['price'] ?? {}),
    );
  }
}

class GoogleReview {
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReview({
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    return GoogleReview(
      overallRating: (json['overallRating'] as num?)?.toDouble() ?? 0.0,
      totalUserRating: json['totalUserRating'] ?? 0,
      withoutDecimal: json['withoutDecimal'] ?? 0,
    );
  }
}

