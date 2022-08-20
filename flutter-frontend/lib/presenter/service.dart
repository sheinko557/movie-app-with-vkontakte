import 'package:http/http.dart' as http;
import 'package:movie/models/about_model.dart';
import 'package:movie/models/data_model.dart';
import 'package:movie/models/index_model.dart';
import 'package:movie/models/post_model.dart';
import 'dart:convert';
import 'package:movie/models/response_model.dart';

class Service{

  String _apiUrl = 'https://darkmoon.sundaygroup.tk/api/v1/';
  String error = "Error.";
  String success = 'Success.';

  Future<ResponseModel> getIndex(version) async{
    
    var response = await http.get(Uri.parse(_apiUrl + 'index?version=$version'));
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      IndexResponseModel resData = IndexResponseModel(
        popular: jsonData['popular'],
        newest: jsonData['new'],
        category: jsonData['categories'],
        ads: jsonData['slider_images'],
        notification: jsonData['notification']
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getPopular(int nextPage) async{
    
    List<PostResponseModel> posts = [];
    var response;
    
    if(nextPage == null || nextPage == 0){
      response = await http.get(Uri.parse(_apiUrl + 'popular'));
    }else{
      response = await http.get(Uri.parse(_apiUrl + 'popular?page=$nextPage'));
    }
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      jsonData['data'].forEach((_data){
        PostResponseModel data = PostResponseModel(
          id: _data['id'],
          title: _data['title'],
          url: _data['url'],
          image: _data['image'],
          duration: _data['duration'],
          totalView: _data['total_view'],
          description: _data['description'],
          screenshots: _data['screenshots'],
          createdAt: _data['created_at'],
          category: _data['category'][0]['name'],
        );
        posts.add(data);
      });
      DataResponseModel resData = DataResponseModel(
        currentPage: jsonData['current_page'],
        data: posts,
        lastPage: jsonData['last_page'],
        adsSlider: jsonData['slider_images'],
        adsGrid: jsonData['card_images'],
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getNewest(int nextPage) async{
    
    List<PostResponseModel> posts = [];
    var response;
    
    if(nextPage == null || nextPage == 0){
      response = await http.get(Uri.parse(_apiUrl + 'new'));
    }else{
      response = await http.get(Uri.parse(_apiUrl + 'new?page=$nextPage'));
    }


    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      jsonData['data'].forEach((_data){
        PostResponseModel data = PostResponseModel(
          id: _data['id'],
          title: _data['title'],
          url: _data['url'],
          image: _data['image'],
          duration: _data['duration'],
          totalView: _data['total_view'],
          description: _data['description'],
          screenshots: _data['screenshots'],
          createdAt: _data['created_at'],
          category: _data['category'][0]['name'],
        );
        posts.add(data);
      });
      DataResponseModel resData = DataResponseModel(
        currentPage: jsonData['current_page'],
        data: posts,
        lastPage: jsonData['last_page'],
        adsSlider: jsonData['slider_images'],
        adsGrid: jsonData['card_images'],
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getSearch(String _title, int nextPage) async{
    
    List<PostResponseModel> posts =[];
    var response;

    if(nextPage == null || nextPage == 0){
      response = await http.get(Uri.parse(_apiUrl + 'search/$_title'));
    }else{
      response = await http.get(Uri.parse(_apiUrl + 'search/$_title?page=$nextPage'));
    }

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      jsonData['data'].forEach((_data){
        PostResponseModel data = PostResponseModel(
          id: _data['id'],
          title: _data['title'],
          url: _data['url'],
          image: _data['image'],
          duration: _data['duration'],
          totalView: _data['total_view'],
          description: _data['description'],
          screenshots: _data['screenshots'],
          createdAt: _data['created_at'],
        );
        posts.add(data);
      });
      DataResponseModel resData = DataResponseModel(
        currentPage: jsonData['current_page'],
        data: posts,
        lastPage: jsonData['last_page'],
        adsSlider: jsonData['slider_images'],
        adsGrid: jsonData['card_images'],
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getCategory(int _categroy, int nextPage) async{

    List<PostResponseModel> posts =[];
    var response;

    if(nextPage == null || nextPage == 0){
      response = await http.get(Uri.parse(_apiUrl + 'category/$_categroy'));
    }else{
      response = await http.get(Uri.parse(_apiUrl + 'category/$_categroy?page=$nextPage'));
    }

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      jsonData['posts']['data'].forEach((_data){
        PostResponseModel data = PostResponseModel(
          id: _data['id'],
          title: _data['title'],
          url: _data['url'],
          image: _data['image'],
          duration: _data['duration'],
          totalView: _data['total_view'],
          description: _data['description'],
          screenshots: _data['screenshots'],
          createdAt: _data['created_at'],
          category: _data['category'][0]['name']
        );
        posts.add(data);
      });
      DataResponseModel resData = DataResponseModel(
        currentPage: jsonData['posts']['current_page'],
        data: posts,
        lastPage: jsonData['posts']['last_page'],
        adsSlider: jsonData['posts']['slider_images'],
        adsGrid: jsonData['posts']['card_images'],
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getPost(int _id) async{
    
    var response = await http.get(Uri.parse(_apiUrl + 'post/$_id'));
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      return ResponseModel(status: response.statusCode, data: jsonData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getPolicy() async{
    
    var response = await http.get(Uri.parse(_apiUrl + 'policy'));
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      var resData = jsonData;
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> getAbout() async{
    
    var response = await http.get(Uri.parse(_apiUrl + 'about-us'));
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      AboutResponseModel resData = AboutResponseModel(
        name: jsonData['name'],
        logo: jsonData['logo'],
        about: jsonData['about'],
        contact: jsonData['contact'],
        downloadLink: jsonData['dlink']
      );
      return ResponseModel(status: response.statusCode, data: resData, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

  Future<ResponseModel> register(deviceId) async{
    
    var response = await http.post(
      Uri.parse(_apiUrl + 'register'),
      body: {
        'device_id' : deviceId,
      }  
    );
    if(response.statusCode == 200){
      return ResponseModel(status: response.statusCode, message: success);
    }
    else{
      return ResponseModel(status: response.statusCode, message: error);
    }

  }

}