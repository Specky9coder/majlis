import 'dart:core';

import 'package:almajlis/core/wrappers/AlMajlisEducation.dart';
import 'package:almajlis/core/wrappers/Device.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'AlMajlisAvailabilityDays.dart';

part 'User.jser.dart';

class User {
  @Field(decodeFrom: "first_name", encodeTo: "first_name", isNullable: true, dontDecode: false, dontEncode: false)
  String firstName;
  @Field(decodeFrom: "last_name", encodeTo: "last_name", isNullable: true, dontDecode: false, dontEncode: false)
  String lastName;
  @Field(decodeFrom: "phone_number", encodeTo: "phone_number", isNullable: true, dontDecode: false, dontEncode: false)
  String phone_number;
  @Field(decodeFrom: "occupation", encodeTo: "occupation", isNullable: true, dontDecode: false, dontEncode: false)
  String occupation;
  @Field(decodeFrom: "_id", encodeTo: "_id", isNullable: true, dontDecode: false, dontEncode: false)
  String userId;
  @Field(decodeFrom: "bio", encodeTo: "bio", isNullable: true, dontDecode: false, dontEncode: false)
  String bio;
  @Field(decodeFrom: "thumb", encodeTo: "thumb", isNullable: true, dontDecode: false, dontEncode: false)
  String thumbUrl;
  @Field(decodeFrom: "video_intro", encodeTo: "video_intro", isNullable: true, dontDecode: false, dontEncode: false)
  String videoUrl;
  @Field(decodeFrom: "link", encodeTo: "link", isNullable: true, dontDecode: false, dontEncode: false)
  String link;
  @Field(decodeFrom: "bod", encodeTo: "bod", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime birthdate;
  @Field(decodeFrom: "company_name", encodeTo: "company_name", isNullable: true, dontDecode: false, dontEncode: false)
  String companyName;
  @Field(decodeFrom: "company_thumb", encodeTo: "company_thumb", isNullable: true, dontDecode: false, dontEncode: false)
  String companyThumb;
  @Field(decodeFrom: "work_start", encodeTo: "work_start", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime workStart;
  @Field(decodeFrom: "work_end", encodeTo: "work_end", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime workEnd;
  @Field(decodeFrom: "is_current_company", encodeTo: "is_current_company", isNullable: true, dontDecode: false, dontEncode: false)
  bool isCurrent;
  @Field(decodeFrom: "is_pro", encodeTo: "is_pro", isNullable: true, dontDecode: false, dontEncode: true)
  bool isPro;
  @Field(decodeFrom: "createdAt", encodeTo: "createdAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime createdAt;
  @Field(decodeFrom: "updatedAt", encodeTo: "updatedAt", isNullable: true, dontDecode: false, dontEncode: false)
  DateTime updatedAt;
  @Field(decodeFrom: "is_public", encodeTo: "is_public", isNullable: true, dontDecode: false, dontEncode: false)
  bool isPublic;
  @Field(decodeFrom: "is_following", encodeTo: "is_following", isNullable: true, dontDecode: false, dontEncode: false)
  bool isFollowing;
  @Field(decodeFrom: "is_online", encodeTo: "is_online", isNullable: true, dontDecode: false, dontEncode: false)
  bool isOnline;
  @Field(decodeFrom: "is_verified", encodeTo: "is_verified", isNullable: true, dontDecode: false, dontEncode: false)
  bool isVerified;
  @Field(decodeFrom: "active", encodeTo: "active", isNullable: true, dontDecode: false, dontEncode: false)
  bool active;
  @Field(decodeFrom: "iban", encodeTo: "iban", isNullable: true, dontDecode: false, dontEncode: false)
  String iban;
  @Field(decodeFrom: "call_title", encodeTo: "call_title", isNullable: true, dontDecode: false, dontEncode: false)
  String callTitle;
  @Field(decodeFrom: "call_duration", encodeTo: "call_duration", isNullable: true, dontDecode: false, dontEncode: false)
  int callDuration;
  @Field(decodeFrom: "availability_days", encodeTo: "availability_days", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisAvailabilityDays availabilityDays;
  @Field(decodeFrom: "availability_start", encodeTo: "availability_start", isNullable: true, dontDecode: false, dontEncode: false)
  int availabilityStart;
  @Field(decodeFrom: "availability_end", encodeTo: "availability_end", isNullable: true, dontDecode: false, dontEncode: false)
  int availabilityEnd;
  @Field(decodeFrom: "call_time_zone", encodeTo: "call_time_zone", isNullable: true, dontDecode: false, dontEncode: false)
  String callTimeZone;
  @Field(decodeFrom: "country", encodeTo: "country", isNullable: true, dontDecode: false, dontEncode: false)
  String country;
  @Field(decodeFrom: "city", encodeTo: "city", isNullable: true, dontDecode: false, dontEncode: false)
  String city;
  @Field(decodeFrom: "device", encodeTo: "device", isNullable: true, dontDecode: false, dontEncode: false)
  Device device;
  @Field(decodeFrom: "fcm_token", encodeTo: "fcm_token", isNullable: true, dontDecode: false, dontEncode: false)
  String fcmToken;
  @Field(decodeFrom: "education", encodeTo: "education", isNullable: true, dontDecode: false, dontEncode: false)
  AlMajlisEducation education;
  @Field(decodeFrom: "skills", encodeTo: "skills", isNullable: true, dontDecode: false, dontEncode: false)
  List<String> skills;
  @Field(decodeFrom: "post_count", encodeTo: "post_count", isNullable: true, dontDecode: false, dontEncode: true)
  int postCount;
  @Field(decodeFrom: "message_count", encodeTo: "message_count", isNullable: true, dontDecode: false, dontEncode: true)
  int messageCount;
  @Field(decodeFrom: "contact_count", encodeTo: "contact_count", isNullable: true, dontDecode: false, dontEncode: true)
  int contactCount;
  @Field(decodeFrom: "reply_count", encodeTo: "reply_count", isNullable: true, dontDecode: false, dontEncode: false)
  int replyCounts;
  @Field(decodeFrom: "like_count", encodeTo: "like_count", isNullable: true, dontDecode: false, dontEncode: true)
  int likeCount;
  @Field(decodeFrom: "forward_count", encodeTo: "forward_count", isNullable: true, dontDecode: false, dontEncode: true)
  int forwardCount;
  @Field(decodeFrom: "share_count", encodeTo: "share_count", isNullable: true, dontDecode: false, dontEncode: true)
  int shareCount;
  @Field(decodeFrom: "invitation_count", encodeTo: "invitation_count", isNullable: true, dontDecode: false, dontEncode: true)
  int inviteCount;
  @Field(decodeFrom: "call_count", encodeTo: "call_count", isNullable: true, dontDecode: false, dontEncode: true)
  int callCount;
  @Field(decodeFrom: "profile_view_count", encodeTo: "profile_view_count", isNullable: true, dontDecode: false, dontEncode: true)
  int profileViewCount;
  @Field(decodeFrom: "meeting_charges", encodeTo: "meeting_charges", isNullable: true, dontDecode: false, dontEncode: false)
  num meetingCharges;
  @Field(decodeFrom: "service_charges", encodeTo: "service_charges", isNullable: true, dontDecode: false, dontEncode: false)
  num serviceCharges;
  @Field(decodeFrom: "total_charges", encodeTo: "total_charges", isNullable: true, dontDecode: false, dontEncode: false)
  num totalCharges;
  @Field(decodeFrom: "meeting_count", encodeTo: "meeting_count", isNullable: true, dontDecode: false, dontEncode: true)
  int meetingCount;
  @Field(decodeFrom: "attended_meeting_count", encodeTo: "attended_meeting_count", isNullable: true, dontDecode: false, dontEncode: true)
  int attendedMeetingCount;
  @Field(decodeFrom: "booking_count", encodeTo: "booking_count", isNullable: true, dontDecode: false, dontEncode: true)
  int bookingCount;
  @Field(decodeFrom: "attended_booking_count", encodeTo: "attended_booking_count", isNullable: true, dontDecode: false, dontEncode: true)
  int attendedBookingCount;
  @Field(decodeFrom: "video_intro_thumb", encodeTo: "video_intro_thumb", isNullable: true, dontDecode: false, dontEncode: false)
  String videoIntroThumb;
  @Field(decodeFrom: "timezone", encodeTo: "timezone", isNullable: true, dontDecode: false, dontEncode: false)
  String timeZone;
  @Field(decodeFrom: "timezone_name", encodeTo: "timezone_name", isNullable: true, dontDecode: false, dontEncode: false)
  String timeZoneName;

  static final serializer = UserSerializer();
  Map<String, dynamic> toJson() => serializer.toMap(this);
  static User fromMap(Map map) => serializer.fromMap(map);


  String toString() => toJson().toString();
}

@GenSerializer()
class UserSerializer extends Serializer<User> with _$UserSerializer {}

