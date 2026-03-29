part of 'ai_image_search_cubit.dart';

abstract class AiImageSearchState {}

class AiImageSearchInitial extends AiImageSearchState {}

class AiImageSearchLoading extends AiImageSearchState {}

class AiImageSearchSuccess extends AiImageSearchState {
  final bool isCarPart;
  final String? partName;
  final String? partNumber;
  final List<String> matchedProductIds;

  AiImageSearchSuccess({
    required this.isCarPart,
    this.partName,
    this.partNumber,
    this.matchedProductIds = const [],
  });
}

class AiImageSearchFailure extends AiImageSearchState {
  final String message;

  AiImageSearchFailure(this.message);
}
