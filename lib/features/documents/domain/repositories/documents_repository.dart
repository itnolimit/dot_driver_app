import 'dart:io';
import 'dart:typed_data';
import '../entities/document.dart';

abstract class DocumentsRepository {
  Future<List<Document>> getDocuments(String driverId);
  Future<Document?> getDocument(String id);
  Future<void> saveDocument(Document document);
  Future<void> updateDocument(Document document);
  Future<void> deleteDocument(String id);
  Future<List<Document>> getExpiringDocuments(String driverId, {int daysFromNow = 30});
  Future<String> saveDocumentFile(Uint8List fileBytes, String fileName);
  Future<File?> getDocumentFile(String filePath);
  Future<void> shareDocumentWithCompany(String documentId, String companyId);
  Future<void> revokeDocumentSharing(String documentId, String companyId);
  Future<List<Document>> getDocumentsByType(String driverId, DocumentType type);
  Future<List<Document>> searchDocuments(String driverId, String query);
}