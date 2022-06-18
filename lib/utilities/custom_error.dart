enum AppError {
  NotFound,
  UnAuthorized,
  UnprocessableEntity
}

class CustomError {
  final AppError key;
  final String? message;

  const CustomError({
    required this.key,
    this.message,
  });
}