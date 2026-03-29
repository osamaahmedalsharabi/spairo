import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/ai_image_search_service.dart';
import 'package:sparioapp/feature/user_feature/products/domain/repositories/products_repo.dart';

part 'ai_image_search_state.dart';

class AiImageSearchCubit extends Cubit<AiImageSearchState> {
  final AiImageSearchService _service;
  final ProductsRepo _productsRepo;

  AiImageSearchCubit(this._service, this._productsRepo) : super(AiImageSearchInitial());

  Future<void> analyzeImage(File imageFile) async {
    emit(AiImageSearchLoading());
    try {
      final result = await _service.analyzeImage(imageFile);
      final isCarPart = result['isCarPart'] as bool? ?? false;
      
      if (!isCarPart) {
        emit(AiImageSearchFailure('عذراً، الصورة لا تبدو كقطعة غيار لسيارة.'));
        return;
      }
      
      final partName = result['partName']?.toString() ?? '';
      final partNumber = result['partNumber']?.toString() ?? '';
      
      List<String> matchedIds = [];

      final productsResult = await _productsRepo.getAllProducts();
      
      // Ensure asynchronous processing for fold
      await productsResult.fold(
        (failure) async {}, 
        (products) async {
          var candidates = products.where(
            (p) => (p.name.toLowerCase().contains(partName.trim().toLowerCase()) || 
                    p.categoryName.toLowerCase().contains(partName.trim().toLowerCase())) &&
                   p.image.isNotEmpty
          ).toList();

          // إذا لم يجد تطابقاً نصياً، أرسل جميع المنتجات التي تحتوي صورة للمقارنة البصرية
          if (candidates.isEmpty || partName.trim().isEmpty) {
             candidates = products.where((p) => p.image.isNotEmpty).toList();
          }

          if (candidates.isNotEmpty) {
            final Map<String, String> candidateImages = {};
            for (var c in candidates) {
              if (c.image.isNotEmpty) {
                candidateImages[c.id] = c.image;
              }
            }
            matchedIds = await _service.matchWithImages(imageFile, candidateImages);
          }
        }
      );

      emit(AiImageSearchSuccess(
        isCarPart: isCarPart,
        partName: partName,
        partNumber: partNumber,
        matchedProductIds: matchedIds,
      ));
    } catch (e) {
      emit(AiImageSearchFailure(e.toString()));
    }
  }
}
