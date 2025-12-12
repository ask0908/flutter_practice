import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_practice/api/user_api.dart";
import "package:flutter_practice/model/user_dto.dart";
import "package:logger/logger.dart";

class RetrofitTest extends StatefulWidget {
  const RetrofitTest({super.key});

  @override
  State<RetrofitTest> createState() => _RetrofitTestState();
}

class _RetrofitTestState extends State<RetrofitTest> {
  late final UserApi _userApi;
  late final Logger _logger;
  List<UserDto> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeLogger();
    _initializeApi();
    _fetchUsers();
  }

  void _initializeLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  void _initializeApi() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
          "Accept": "application/json",
          "Accept-Language": "ko-KR,ko;q=0.9",
          "Accept-Encoding": "gzip, deflate, br",
          "Connection": "keep-alive",
        },
        followRedirects: true,
        maxRedirects: 5,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i("=== API 요청 ===\n"
              "메서드 : ${options.method}\n"
              "URL : ${options.uri}\n"
              "헤더 : ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d("=== API 응답 ===\n"
              "상태코드 : ${response.statusCode}\n"
              "데이터 : ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
              "=== API 에러 ===\n"
              "상태코드 : ${error.response?.statusCode}\n"
              "메시지 : ${error.message}\n"
              "타입 : ${error.type}",
              error: error,
              stackTrace: error.stackTrace);
          return handler.next(error);
        },
      ),
    );

    _userApi = UserApi(dio);
  }

  Future<void> _fetchUsers() async {
    _logger.d("사용자 목록 조회 시작");

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _userApi.getUsers();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _users = result;
        });
      }
    } on DioException catch (e, stackTrace) {
      _logger.e("사용자 목록 조회 실패", error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _handleDioError(e);
        });
      }
    } catch (e, stackTrace) {
      _logger.e("알 수 없는 에러 발생", error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "알 수 없는 에러: $e";
        });
      }
    }
  }

  String _handleDioError(DioException error) {
    if (error.response?.statusCode == 403) {
      _logger.w("403 Forbidden - Cloudflare 차단 가능성");
      return "접근이 거부되었습니다.\nCloudflare에 의해 차단되었을 수 있습니다.\n\n다른 네트워크로 시도하세요";
    }

    final errorMessage = switch (error.type) {
      DioExceptionType.connectionTimeout => "연결 시간 초과",
      DioExceptionType.sendTimeout => "전송 시간 초과",
      DioExceptionType.receiveTimeout => "응답 시간 초과",
      DioExceptionType.badResponse => "서버 오류: ${error.response?.statusCode}",
      DioExceptionType.cancel => "요청 취소됨",
      DioExceptionType.connectionError => "네트워크 연결 에러\n인터넷 연결을 확인해주세요",
      _ => "네트워크 에러: ${error.message}",
    };

    _logger.w("에러 처리: $errorMessage");
    return errorMessage;
  }

  @override
  void dispose() {
    _logger.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit 테스트"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchUsers,
            tooltip: "새로고침",
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingView();

    if (_errorMessage != null) return _buildErrorView();

    if (_users.isEmpty) return _buildEmptyView();

    return _buildUserList();
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("로딩 중..."),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchUsers,
              icon: const Icon(Icons.refresh),
              label: const Text("재시도"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text("사용자 데이터 없음"),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _users.length,
      itemBuilder: (context, index) => _buildUserCard(_users[index]),
    );
  }

  Widget _buildUserCard(UserDto user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildUserAvatar(user.name),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildUserSubtitle(user),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: () {
          _logger.d("사용자 상세 정보 - name : ${user.name}, id : ${user.id}");
          _showUserDetail(user);
        },
      ),
    );
  }

  Widget _buildUserAvatar(String name) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        name[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserSubtitle(UserDto user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text("@${user.username}"),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showUserDetail(UserDto user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: _buildDialogTitle(user),
        content: _buildDialogContent(user),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("닫기"),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTitle(UserDto user) {
    return Row(
      children: [
        _buildUserAvatar(user.name),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            user.name,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent(UserDto user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBasicInfoSection(user),
          const SizedBox(height: 16),
          _buildAddressSection(user.address),
          const SizedBox(height: 16),
          _buildCompanySection(user.company),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(UserDto user) {
    return _buildSection(
      title: "기본 정보",
      children: [
        _buildInfoRow("ID", user.id.toString()),
        _buildInfoRow("사용자명", user.username),
        _buildInfoRow("이메일", user.email),
        _buildInfoRow("전화번호", user.phone),
        _buildInfoRow("웹사이트", user.website),
      ],
    );
  }

  Widget _buildAddressSection(Address address) {
    return _buildSection(
      title: "주소",
      children: [
        _buildInfoRow("거리", address.street),
        _buildInfoRow("스위트", address.suite),
        _buildInfoRow("도시", address.city),
        _buildInfoRow("우편번호", address.zipcode),
        _buildInfoRow("위도", address.geo.lat),
        _buildInfoRow("경도", address.geo.lng),
      ],
    );
  }

  Widget _buildCompanySection(Company company) {
    return _buildSection(
      title: "회사",
      children: [
        _buildInfoRow("회사명", company.name),
        _buildInfoRow("캐치프레이즈", company.catchPhrase),
        _buildInfoRow("사업", company.bs),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}