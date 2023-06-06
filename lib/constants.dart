class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';

  // Get Users API
  static const String getUsersEndpoint = '/api/users';
  static const int getUsersSuccessCode = 200;

  // Create User API
  static const String createUserEndpoint = '/api/users';
  static const int createUserSuccessCode = 201;

  // Get Daily Message API
  static const String getDailyMessageEndpoint = '/api/daily-message';
  static const int getDailyMessageSuccessCode = 200;

  // Get Posts API
  static const String getPostsEndpoint = '/api/posts';
  static const int getPostsSuccessCode = 200;

  // Create Post API
  static const String createPostEndpoint = '/api/posts';
  static const int createPostSuccessCode = 201;

  // Create Comment API
  static const String createCommentEndpoint = '/api/comments';
  static const int createCommentSuccessCode = 201;

  // Create Message API
  static const String createMessageEndpoint = '/api/messages';
  static const int createMessageSuccessCode = 201;

  // Get Messages API
  static const String getMessagesEndpoint = '/api/messages';
  static const int getMessagesSuccessCode = 200;
}
