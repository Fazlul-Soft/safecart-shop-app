import 'dart:convert';

ProductBySubcategoryModel productBySubcategoryModelFromJson(String str) =>
    ProductBySubcategoryModel.fromJson(json.decode(str));

String productBySubcategoryModelToJson(ProductBySubcategoryModel data) =>
    json.encode(data.toJson());

class ProductBySubcategoryModel {
  ProductBySubcategoryModel({
    required this.data,
    this.nextPageUrl,
  });

  List<Datum2> data;
  String? nextPageUrl;

  factory ProductBySubcategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductBySubcategoryModel(
        data: json["data"] != null
            ? List<Datum2>.from(json["data"].map((x) => Datum2.fromJson(x)))
            : [],
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class Datum2 {
  Datum2({
    this.prdId,
    this.title,
    this.imgUrl,
    this.campaignPercentage,
    this.price,
    this.discountPrice,
    this.badge,
    this.campaignProduct,
    this.stockCount,
    required this.avgRatting,
    this.isCartAble,
    this.vendorId,
    this.vendorName,
    this.categoryId,
    this.subCategoryId,
    required this.childCategoryIds,
    this.endDate,
    this.randomKey,
    this.randomSecret,
    this.campaignStock,
  });

  dynamic prdId;
  String? title;
  String? imgUrl;
  dynamic campaignPercentage;
  dynamic price;
  dynamic discountPrice;
  String? badge;
  bool? campaignProduct;
  dynamic stockCount;
  double avgRatting;
  bool? isCartAble;
  dynamic vendorId;
  String? vendorName;
  dynamic categoryId;
  dynamic subCategoryId;
  List<dynamic> childCategoryIds;
  DateTime? endDate;
  dynamic randomKey;
  dynamic randomSecret;
  int? campaignStock;

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
        prdId: json["id"], // Map from id since prd_id isn't set in the response
        title: json["name"], // Map from name since title isn't set
        imgUrl: json["image"], // Map from image (rendered path)
        campaignPercentage: json["campaign_percentage"] is String
            ? double.tryParse(json["campaign_percentage"])
            : json["campaign_percentage"],
        price: json["price"] is String
            ? num.tryParse(json["price"])
            : json["price"],
        discountPrice: json["sale_price"] is String
            ? double.tryParse(json["sale_price"])
            : json["sale_price"], // Map sale_price to discount_price
        badge: json["badge"]?["name"] ?? json["badge"]?["badge_name"], // Map badge name
        campaignProduct: json["campaign_product"],
        stockCount: 0, // Not directly available; set to 0 (adjust if inventory is added)
        avgRatting: json["ratings_avg_rating"] is String
            ? num.tryParse(json["ratings_avg_rating"])
            : json["ratings_avg_rating"]?.toDouble() ?? 0,
        isCartAble: json["is_cart_able"] ?? true, // Not directly available; default to true
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"], // May need adjustment if not a column
        categoryId: json["category"]?["id"],
        subCategoryId: json["sub_categories"] != null && json["sub_categories"] is List,

        childCategoryIds: json["child_category"] != null && json["child_category"] is List
            ? json["child_category"].map((x) => x["id"]).toList()
            : [], // Extract from childCategory
        endDate: json["end_date"] == null
            ? null
            : DateTime.tryParse(json["end_date"]),
        randomKey: json["random_key"],
        randomSecret: json["random_secret"],
        campaignStock: json["campaign_stock"] is String
            ? int.tryParse(json["campaign_stock"])
            : json["campaign_stock"]?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": prdId,
        "name": title,
        "image": imgUrl,
        "campaign_percentage": campaignPercentage,
        "price": price,
        "sale_price": discountPrice,
        "badge": badge,
        "campaign_product": campaignProduct,
        "stock_count": stockCount,
        "avg_ratting": avgRatting,
        "is_cart_able": isCartAble,
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "child_category_ids": childCategoryIds,
        "end_date": endDate?.toIso8601String(),
        "random_key": randomKey,
        "random_secret": randomSecret,
        "campaign_stock": campaignStock,
      };
}