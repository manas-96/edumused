import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIClient{
  var bannerImage=[
    {
      "image":"https://www.edumused.com/images/banners/16339344031191.jpg"
    },
    {
      "image":"https://www.edumused.com/images/banners/16339335694464.jpg"
    }
  ];
  final baseUrl="https://www.edumused.com/api/";
  _buildHeader(){
    return { 'Accept' : 'application/json', 'cache-control' : 'no-cache'};
  }
  static errorToast(String msg) {
    return SnackBar(
      content: Text(msg, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
      duration: Duration(seconds:2),
    );
  }
  static successToast(String msg) {
    return SnackBar(
      content: Text(msg, style: TextStyle(color: Colors.white),),
      duration: Duration(seconds:2),
    );
  }
  buildHeaderWithToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    return { 'Accept' : 'application/json', 'Authorization' : 'Bearer $token'};
  }
  storeAuth(String token)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    print(preferences.getString("token"));
  }
  storeUserType(String type)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userType", type);
    print(preferences.getString("userType"));
  }
  storeProfile(data)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lmsToken", data["lms_token"]);
    preferences.setString("username", data["user_name"]);
    preferences.setString("name", data["name"]);
    preferences.setString("email", data["email"]);
    preferences.setString("image", data["image"]);
    preferences.setString("phone", data["phone"]);
    print(preferences.getString("phone"));
  }
  login(body)async{
    final header = _buildHeader();
    final response = await http.post("https://www.edumused.com/api/login",headers: header,body: body);
    print(response.statusCode);
    print(json.decode(response.body));
    if(response.statusCode==200){
      var data = json.decode(response.body);
       storeAuth(data["access_token"]);
       profile();
      return "success";
    }
    else{
      return "failed";
    }
  }
  signup(body)async{
    final header = _buildHeader();
    final response = await http.post("${baseUrl}signup",headers: header,body: body);
    print(response.statusCode);
    print(json.decode(response.body));
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return "success";
    }
    else{
      return "failed";
    }
  }
  profile()async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"profile",headers: header,);
    if(response.statusCode==200){
      final data=json.decode(response.body);
      storeUserType(data["user_type"].toString());
      storeProfile(data);
      return data;
    }
    else{
      return "failed";
    }
  }
  updateProfile(body)async{
    final header = await buildHeaderWithToken();
    final response = await http.put(baseUrl+"profile",headers: header,body: body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  changePassword(body)async{
    final header = await buildHeaderWithToken();
    final response = await http.post(baseUrl+"change-password",headers: header,body: body);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  productCategory()async{
    final header = await _buildHeader();
    final response = await http.get(baseUrl+"categories",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  productByCategory(String limit, String offset, String ordering, String id)async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"courses?limit=$limit&offset=$offset&ordering=$ordering&category_id=$id",headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  productBySubCategory(String limit, String offset, String ordering, String id,String sub)async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+
        "courses?limit=$limit&offset=$offset&ordering=$ordering&category_id=$id&child_subcategory_id=$sub",
      headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  productSubCategory(String id)async{
    final header = await _buildHeader();
    final response = await http.get(baseUrl+"categories/$id/subcategories",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  productSubCategoryChild(String id, String categoryId)async{
    final header = await _buildHeader();
    final response = await http.get(baseUrl+"categories/$categoryId/subcategories/$id/child-subcategories",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  courses(String limit, String offset, String ordering)async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"courses?limit=$limit&offset=$offset&ordering=$ordering",headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  search(String limit, String offset, String ordering, String searchKey)async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"courses?limit=$limit&offset=$offset&ordering=$ordering&keywords=$searchKey",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  wishlist()async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"wishlists",headers: header,);
    print(response.statusCode);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  addWishList(body)async{
    final header = await buildHeaderWithToken();
    final response = await http.post(baseUrl+"wishlists",headers: header,body: body);
    print(response.statusCode);
    if(response.statusCode==201){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  removeWishList(String productId, )async{
    final header = await buildHeaderWithToken();
    final response = await http.delete(baseUrl+"wishlists/$productId",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  cart()async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"carts",headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  addCart(body)async{
    final header = await buildHeaderWithToken();
    final response = await http.post(baseUrl+"carts",headers: header,body: body);
    print(response.body);
    if(response.statusCode==201){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  removeCart(String productId, )async{
    final header = await buildHeaderWithToken();
    final response = await http.delete(baseUrl+"carts/$productId",headers: header,);
    print(response.body);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  orderList()async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"orders",headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  orderDetails(String id)async{
    final header = await buildHeaderWithToken();
    final response = await http.get(baseUrl+"orders/$id",headers: header,);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
  placeOrder(body)async{
    final header = await buildHeaderWithToken();
    final response = await http.post(baseUrl+"orders",headers: header,body: body);
    print(response.body);
    if(response.statusCode==201){
      return json.decode(response.body);
    }
    else{
      return "failed";
    }
  }
}