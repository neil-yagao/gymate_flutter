import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_event.dart';

import 'basic_dio.dart';

class CommunityService {
  Dio dio;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  CommunityService(this._scaffoldKey) {
    this.dio = DioInstance.getInstance(_scaffoldKey);
  }

  Future<Post> postNewPost(Post post) async {
    return dio.post("/posts", data: post.toJson()).then((r) {
      return Post.fromJson(r.data);
    }).catchError((e) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("网络连接有些问题")));
    });
  }

  Future<Comment> postNewReply(Comment comment) async {
    return dio.post("/comments", data: comment.toJson()).then((r) {
      return Comment.fromJson(r.data);
    }).catchError((e) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("网络连接有些问题")));
    });
  }

  Future<List<Post>> getViewablePost(User user) async {
    return dio.get('/posts/user/' + user.id.toString() + "/view").then((r) {
      List<Post> posts = List();
      if (r.data != null) {
        (r.data as List).forEach((p) {
          posts.add(Post.fromJson(p));
        });
      }
      return posts;
    }).catchError((e) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("网络连接有些问题")));
    });
  }

  Future<List<Post>> getOwnPost(User user) async {
    return dio.get('/posts/user/' + user.id.toString()).then((r) {
      List<Post> posts = List();
      if (r.data != null) {
        (r.data as List).forEach((p) {
          posts.add(Post.fromJson(p));
        });
      }
      return posts;
    }).catchError((e) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("网络连接有些问题")));
    });
  }

  Future<Post> getPost(int postId) {
    return dio.get('/posts/' + postId.toString()).then((res) {
      if (res.data != null) {
        return Post.fromJson(res.data);
      }
      return null;
    });
  }

  Future recommend(int id, String type, User by) {
    return dio.post('/community/recommend/' + type + "/" + id.toString(),
        data: by);
  }

  Future<Recommend> getRecommend(int id) {
    return dio.post('/recommend/' + id.toString()).then((res) {
      if (res.data == null) {
        return null;
      }
      return Recommend.fromJson(res.data);
    });
  }

  Future<List<User>> getRelatedUsers(int currentUserId) {
    return dio.get('/user-group/partners',
        queryParameters: {"userId": currentUserId}).then((res) {
      List<User> result = List();
      if(res.data != null){
        (res.data as List).forEach((user){
          result.add(User.fromJson(user));
        });
      }
      return result;
    });
  }

}
