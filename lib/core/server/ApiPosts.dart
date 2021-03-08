import "dart:async";
import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/core/server/wrappers/RequestReport.dart';
import 'package:almajlis/core/server/wrappers/ResponseComments.dart';
import 'package:almajlis/core/server/wrappers/ResponseOk.dart';
import 'package:almajlis/core/server/wrappers/ResponsePost.dart';
import 'package:almajlis/core/server/wrappers/ResponsePosts.dart';
import 'package:almajlis/core/server/wrappers/ResponseSearchPost.dart';
import 'package:almajlis/core/server/wrappers/ResponseSignedUrl.dart';

import 'package:almajlis/core/wrappers/AlMajlisComment.dart';
import 'package:almajlis/core/wrappers/AlMajlisPost.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

part 'ApiPosts.jretro.dart';

@GenApiClient(path: "api/posts")
class ApiPosts extends GenericRequestInterceptor with _$ApiPostsClient {
  final resty.Route base;

  ApiPosts(this.base, sessionInterface) : super(base, sessionInterface);

  @PostReq(path: "/")
  Future<ResponseOk> addPost(@AsJson() AlMajlisPost post);

  @GetReq(path: "/")
  Future<ResponsePosts> getPosts(
      @QueryParam("last_post") DateTime timestamp,
      @QueryParam("country") String country,
      @QueryParam("prousers") bool prousers,
      @QueryParam("distance") distance,
      @QueryParam("lat") lat,
      @QueryParam("lng") lng,
      );

  @GetReq(path: "/")
  Future<ResponsePosts> getUserPosts(@QueryParam("userid") String userid);

  @GetReq(path: "/:id")
  Future<ResponsePost> getPostDetails(@PathParam("id") String id);

  @GetReq(path: "/search/:query")
  Future<ResponseSearchPost> searchPosts(
      @PathParam("query") String searchString,@QueryParam("offset")offset);

  @PutReq(path: "/:id")
  Future<ResponseOk> editPost(
      @PathParam("id") String id, @AsJson() AlMajlisPost post);

  @DeleteReq(path: "/:id")
  Future<ResponseOk> deletePost(@PathParam("id") String id);

  @GetReq(path: "/signedurl/:extension")
  Future<ResponseSignedUrl> getSignedUrl(
      @PathParam("extension") String extension);

  @GetReq(path: "/comments/:id")
  Future<ResponseComments> getComments(
      @PathParam("id") String id, @QueryParam("offset") int offset);

  @PostReq(path: "/comments/:id")
  Future<ResponseOk> addComment(
      @AsJson() AlMajlisComment comment, @PathParam("id") String id);

  @PutReq(path: "/like/:id")
  Future<ResponseOk> likePost(@PathParam("id") String id);

  @PutReq(path: "/dislike/:id")
  Future<ResponseOk> dislikePost(@PathParam("id") String id);

  @PutReq(path: "/comment/like/:id")
  Future<ResponseOk> likeComment(@PathParam("id") String id);

  @PutReq(path: "/comment/dislike/:id")
  Future<ResponseOk> dislikeComment(@PathParam("id") String id);

  @PostReq(path: "/report/:id")
  Future<ResponseOk> report(
      @AsJson() RequestReport request, @PathParam("id") String id);

  @PostReq(path: "/comments/report/:id")
  Future<ResponseOk> reportComment(
      @AsJson() RequestReport request, @PathParam("id") String id);

  @DeleteReq(path: "/comments/:id")
  Future<ResponseOk> deleteComment(@PathParam("id") String id);

  @PutReq(path: "/comments/:id")
  Future<ResponseOk> editComment(
      @AsJson() AlMajlisComment comment, @PathParam("id") String id);
}
