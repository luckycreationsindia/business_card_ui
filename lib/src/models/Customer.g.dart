// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['_id'] as String?,
      first_name: json['first_name'] as String? ?? '',
      last_name: json['last_name'] as String?,
      company: json['company'] as String?,
      jobTitle: json['jobTitle'] as String?,
      profile: json['profile'] as String?,
      mainColor: json['mainColor'] as String? ?? '#AC1A2D',
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      linkedin: json['linkedin'] as String?,
      github: json['github'] as String?,
      whatsapp: json['whatsapp'] as String?,
      twitter: json['twitter'] as String?,
      upi: json['upi'] as String?,
      upiData: (json['upiData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      bankDetails: json['bankDetails'] as String?,
      about: json['about'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      '_id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
      'profile': instance.profile,
      'mainColor': instance.mainColor,
      'contacts': instance.contacts,
      'email': instance.email,
      'website': instance.website,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'linkedin': instance.linkedin,
      'github': instance.github,
      'whatsapp': instance.whatsapp,
      'twitter': instance.twitter,
      'upi': instance.upi,
      'upiData': instance.upiData,
      'bankDetails': instance.bankDetails,
      'about': instance.about,
      'notes': instance.notes,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _CustomerRestClient implements CustomerRestClient {
  _CustomerRestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://dapi.myindia.app/api/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Customer> loadCustomer(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Customer>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/c/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Customer.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
