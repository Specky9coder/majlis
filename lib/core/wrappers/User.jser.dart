// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserSerializer implements Serializer<User> {
  Serializer<AlMajlisAvailabilityDays> __alMajlisAvailabilityDaysSerializer;
  Serializer<AlMajlisAvailabilityDays>
      get _alMajlisAvailabilityDaysSerializer =>
          __alMajlisAvailabilityDaysSerializer ??=
              AlMajlisAvailabilityDaysSerializer();
  Serializer<Device> __deviceSerializer;
  Serializer<Device> get _deviceSerializer =>
      __deviceSerializer ??= DeviceSerializer();
  Serializer<AlMajlisEducation> __alMajlisEducationSerializer;
  Serializer<AlMajlisEducation> get _alMajlisEducationSerializer =>
      __alMajlisEducationSerializer ??= AlMajlisEducationSerializer();
  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'first_name', model.firstName);
    setMapValue(ret, 'last_name', model.lastName);
    setMapValue(ret, 'phone_number', model.phone_number);
    setMapValue(ret, 'occupation', model.occupation);
    setMapValue(ret, '_id', model.userId);
    setMapValue(ret, 'bio', model.bio);
    setMapValue(ret, 'thumb', model.thumbUrl);
    setMapValue(ret, 'video_intro', model.videoUrl);
    setMapValue(ret, 'link', model.link);
    setMapValue(ret, 'bod', dateTimeUtcProcessor.serialize(model.birthdate));
    setMapValue(ret, 'company_name', model.companyName);
    setMapValue(ret, 'company_thumb', model.companyThumb);
    setMapValue(
        ret, 'work_start', dateTimeUtcProcessor.serialize(model.workStart));
    setMapValue(ret, 'work_end', dateTimeUtcProcessor.serialize(model.workEnd));
    setMapValue(ret, 'is_current_company', model.isCurrent);
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(
        ret, 'updatedAt', dateTimeUtcProcessor.serialize(model.updatedAt));
    setMapValue(ret, 'is_public', model.isPublic);
    setMapValue(ret, 'is_following', model.isFollowing);
    setMapValue(ret, 'is_online', model.isOnline);
    setMapValue(ret, 'is_verified', model.isVerified);
    setMapValue(ret, 'active', model.active);
    setMapValue(ret, 'iban', model.iban);
    setMapValue(ret, 'call_title', model.callTitle);
    setMapValue(ret, 'call_duration', model.callDuration);
    setMapValue(ret, 'availability_days',
        _alMajlisAvailabilityDaysSerializer.toMap(model.availabilityDays));
    setMapValue(ret, 'availability_start', model.availabilityStart);
    setMapValue(ret, 'availability_end', model.availabilityEnd);
    setMapValue(ret, 'call_time_zone', model.callTimeZone);
    setMapValue(ret, 'country', model.country);
    setMapValue(ret, 'city', model.city);
    setMapValue(ret, 'device', _deviceSerializer.toMap(model.device));
    setMapValue(ret, 'fcm_token', model.fcmToken);
    setMapValue(
        ret, 'education', _alMajlisEducationSerializer.toMap(model.education));
    setMapValue(
        ret, 'skills', codeIterable(model.skills, (val) => val as String));
    setMapValue(ret, 'reply_count', model.replyCounts);
    setMapValue(ret, 'meeting_charges', model.meetingCharges);
    setMapValue(ret, 'service_charges', model.serviceCharges);
    setMapValue(ret, 'total_charges', model.totalCharges);
    setMapValue(ret, 'video_intro_thumb', model.videoIntroThumb);
    setMapValue(ret, 'timezone', model.timeZone);
    setMapValue(ret, 'timezone_name', model.timeZoneName);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = User();
    obj.firstName = map['first_name'] as String;
    obj.lastName = map['last_name'] as String;
    obj.phone_number = map['phone_number'] as String;
    obj.occupation = map['occupation'] as String;
    obj.userId = map['_id'] as String;
    obj.bio = map['bio'] as String;
    obj.thumbUrl = map['thumb'] as String;
    obj.videoUrl = map['video_intro'] as String;
    obj.link = map['link'] as String;
    obj.birthdate = dateTimeUtcProcessor.deserialize(map['bod'] as String);
    obj.companyName = map['company_name'] as String;
    obj.companyThumb = map['company_thumb'] as String;
    obj.workStart =
        dateTimeUtcProcessor.deserialize(map['work_start'] as String);
    obj.workEnd = dateTimeUtcProcessor.deserialize(map['work_end'] as String);
    obj.isCurrent = map['is_current_company'] as bool;
    obj.isPro = map['is_pro'] as bool;
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.updatedAt =
        dateTimeUtcProcessor.deserialize(map['updatedAt'] as String);
    obj.isPublic = map['is_public'] as bool;
    obj.isFollowing = map['is_following'] as bool;
    obj.isOnline = map['is_online'] as bool;
    obj.isVerified = map['is_verified'] as bool;
    obj.active = map['active'] as bool;
    obj.iban = map['iban'] as String;
    obj.callTitle = map['call_title'] as String;
    obj.callDuration = map['call_duration'] as int;
    obj.availabilityDays = _alMajlisAvailabilityDaysSerializer
        .fromMap(map['availability_days'] as Map);
    obj.availabilityStart = map['availability_start'] as int;
    obj.availabilityEnd = map['availability_end'] as int;
    obj.callTimeZone = map['call_time_zone'] as String;
    obj.country = map['country'] as String;
    obj.city = map['city'] as String;
    obj.device = _deviceSerializer.fromMap(map['device'] as Map);
    obj.fcmToken = map['fcm_token'] as String;
    obj.education =
        _alMajlisEducationSerializer.fromMap(map['education'] as Map);
    obj.skills =
        codeIterable<String>(map['skills'] as Iterable, (val) => val as String);
    obj.postCount = map['post_count'] as int;
    obj.messageCount = map['message_count'] as int;
    obj.contactCount = map['contact_count'] as int;
    obj.replyCounts = map['reply_count'] as int;
    obj.likeCount = map['like_count'] as int;
    obj.forwardCount = map['forward_count'] as int;
    obj.shareCount = map['share_count'] as int;
    obj.inviteCount = map['invitation_count'] as int;
    obj.callCount = map['call_count'] as int;
    obj.profileViewCount = map['profile_view_count'] as int;
    obj.meetingCharges = map['meeting_charges'] as num;
    obj.serviceCharges = map['service_charges'] as num;
    obj.totalCharges = map['total_charges'] as num;
    obj.meetingCount = map['meeting_count'] as int;
    obj.attendedMeetingCount = map['attended_meeting_count'] as int;
    obj.bookingCount = map['booking_count'] as int;
    obj.attendedBookingCount = map['attended_booking_count'] as int;
    obj.videoIntroThumb = map['video_intro_thumb'] as String;
    obj.timeZone = map['timezone'] as String;
    obj.timeZoneName = map['timezone_name'] as String;
    return obj;
  }
}
