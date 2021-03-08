// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiPosts.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$ApiPostsClient implements ApiClient {
  final String basePath = "api/posts";
  Future<ResponseOk> addPost(AlMajlisPost post) async {
    var req = base.post.path(basePath).path("/").json(jsonConverter.to(post));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponsePosts> getPosts(DateTime timestamp, String country,
      bool prousers, dynamic distance, dynamic lat, dynamic lng) async {
    var req = base.get
        .path(basePath)
        .path("/")
        .query("last_post", timestamp)
        .query("country", country)
        .query("prousers", prousers)
        .query("distance", distance)
        .query("lat", lat)
        .query("lng", lng);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponsePosts> getUserPosts(String userid) async {
    var req = base.get.path(basePath).path("/").query("userid", userid);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponsePost> getPostDetails(String id) async {
    var req = base.get.path(basePath).path("/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseSearchPost> searchPosts(
      String searchString, dynamic offset) async {
    var req = base.get
        .path(basePath)
        .path("/search/:query")
        .pathParams("query", searchString)
        .query("offset", offset);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> editPost(String id, AlMajlisPost post) async {
    var req = base.put
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(post));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> deletePost(String id) async {
    var req = base.delete.path(basePath).path("/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseSignedUrl> getSignedUrl(String extension) async {
    var req = base.get
        .path(basePath)
        .path("/signedurl/:extension")
        .pathParams("extension", extension);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseComments> getComments(String id, int offset) async {
    var req = base.get
        .path(basePath)
        .path("/comments/:id")
        .pathParams("id", id)
        .query("offset", offset);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> addComment(AlMajlisComment comment, String id) async {
    var req = base.post
        .path(basePath)
        .path("/comments/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(comment));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> likePost(String id) async {
    var req = base.put.path(basePath).path("/like/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> dislikePost(String id) async {
    var req = base.put.path(basePath).path("/dislike/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> likeComment(String id) async {
    var req =
        base.put.path(basePath).path("/comment/like/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> dislikeComment(String id) async {
    var req = base.put
        .path(basePath)
        .path("/comment/dislike/:id")
        .pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> report(RequestReport request, String id) async {
    var req = base.post
        .path(basePath)
        .path("/report/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(request));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> reportComment(RequestReport request, String id) async {
    var req = base.post
        .path(basePath)
        .path("/comments/report/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(request));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> deleteComment(String id) async {
    var req =
        base.delete.path(basePath).path("/comments/:id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<ResponseOk> editComment(AlMajlisComment comment, String id) async {
    var req = base.put
        .path(basePath)
        .path("/comments/:id")
        .pathParams("id", id)
        .json(jsonConverter.to(comment));
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
