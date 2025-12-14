import 'package:dio/dio.dart';
import 'dart:collection';
import 'dart:convert';

// IMPORTANT: Use a secure method (like environment variables) for this in a real app.
const String HF_API_TOKEN = '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';

// This is a great multilingual embedding model from Hugging Face for "any language" support.
const String HF_MODEL_ID = 'intfloat/multilingual-e5-large'; 

class HuggingFaceService {
  static final HuggingFaceService _instance = HuggingFaceService._internal();

  factory HuggingFaceService() {
    return _instance;
  }

  // Define the Dio client instance
  late final Dio _dio;

  HuggingFaceService._internal() {
    _dio = Dio(
      BaseOptions(
        // The endpoint URL for feature extraction on the Inference API
        baseUrl: 'https://api-inference.huggingface.co/models/$HF_MODEL_ID',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          "Authorization": "Bearer $HF_API_TOKEN",
          "Content-Type": "application/json",
        },
        responseType: ResponseType.json,
      ),
    );
  }
  
  // In-memory cache for permanent class embeddings
  final Map<String, List<double>> _embeddingCache = HashMap<String, List<double>>();

  /// Generates the embedding vector for a piece of text using the Hugging Face API.
  Future<List<double>?> getEmbeddingVector(String text, {bool cacheResult = false}) async {
    final key = text.toLowerCase().trim();

    // 1. Check Cache
    if (_embeddingCache.containsKey(key)) {
      return _embeddingCache[key];
    }

    // The payload for the Feature Extraction task
    final payload = jsonEncode({
      "inputs": text, // Send the text
      "options": {"wait_for_model": true} // Important: Tells HF to wait if the model is loading
    });

    try {
      // 2. Make the POST request
      final response = await _dio.post(
        '', // Empty string uses the BaseURL defined in BaseOptions
        data: payload,
      );

      // 3. Dio automatically parses the JSON response data
      // HF returns a list of vectors (as a List<List<double>>)
      final List<dynamic> data = response.data;
      
      // Extract the first (and only) vector (List<double>)
      final List<double> vector = (data[0] as List).map((e) => e as double).toList();
      print(vector);

      // 4. Cache the result if requested
      if (cacheResult) {
        _embeddingCache[key] = vector;
      }
      
      

      return vector;

    } on DioError catch (e) {
      // DioError provides structured error info
      print('Hugging Face API Error (Dio): ${e.response?.statusCode}');
      print('Response Body: ${e.response?.data}');
      // A 503 error means the model is loading (if wait_for_model=true) or busy
      return null;
    } catch (e) {
      print('General Embedding Error: $e');
      return null;
    }
  }

  // --- Core Similarity Function ---

  /// Calculates the Dot Product (Cosine Similarity for normalized vectors).
  double calculateDotProduct(List<double> vecA, List<double> vecB) {
    if (vecA.length != vecB.length) return 0.0;
    
    double dot = 0.0;
    for (int i = 0; i < vecA.length; i++) {
      dot += vecA[i] * vecB[i];
    }
    return dot;
  }
}