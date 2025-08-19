import 'dart:io';
import 'dart:typed_data';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/documents_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  Future<List<Document>> getDocuments(String driverId) async {
    try {
      final List<Map<String, dynamic>> documentsData = 
          await _localStorage.getDocuments(driverId);
      
      return documentsData.map((data) => _mapToDocument(data)).toList();
    } catch (e) {
      throw Exception('Failed to load documents: $e');
    }
  }

  @override
  Future<Document?> getDocument(String id) async {
    try {
      final Map<String, dynamic>? documentData = 
          await _localStorage.getDocument(id);
      
      return documentData != null ? _mapToDocument(documentData) : null;
    } catch (e) {
      throw Exception('Failed to load document: $e');
    }
  }

  @override
  Future<void> saveDocument(Document document) async {
    try {
      final Map<String, dynamic> documentData = _documentToMap(document);
      await _localStorage.saveDocument(documentData);
    } catch (e) {
      throw Exception('Failed to save document: $e');
    }
  }

  @override
  Future<void> updateDocument(Document document) async {
    try {
      final Map<String, dynamic> documentData = _documentToMap(document);
      await _localStorage.updateDocument(document.id, documentData);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    try {
      await _localStorage.deleteDocument(id);
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  @override
  Future<List<Document>> getExpiringDocuments(String driverId, {int daysFromNow = 30}) async {
    try {
      final List<Map<String, dynamic>> documentsData = 
          await _localStorage.getExpiringDocuments(driverId, daysFromNow: daysFromNow);
      
      return documentsData.map((data) => _mapToDocument(data)).toList();
    } catch (e) {
      throw Exception('Failed to load expiring documents: $e');
    }
  }

  @override
  Future<String> saveDocumentFile(Uint8List fileBytes, String fileName) async {
    try {
      return await _localStorage.saveDocumentFile(fileBytes, fileName);
    } catch (e) {
      throw Exception('Failed to save document file: $e');
    }
  }

  @override
  Future<File?> getDocumentFile(String filePath) async {
    try {
      return await _localStorage.getDocumentFile(filePath);
    } catch (e) {
      throw Exception('Failed to get document file: $e');
    }
  }

  @override
  Future<void> shareDocumentWithCompany(String documentId, String companyId) async {
    try {
      final document = await getDocument(documentId);
      if (document == null) {
        throw Exception('Document not found');
      }

      final updatedDocument = document.copyWith(
        isSharedWithCompany: true,
        sharedCompanies: [...document.sharedCompanies, companyId],
        updatedAt: DateTime.now(),
      );

      await updateDocument(updatedDocument);
    } catch (e) {
      throw Exception('Failed to share document with company: $e');
    }
  }

  @override
  Future<void> revokeDocumentSharing(String documentId, String companyId) async {
    try {
      final document = await getDocument(documentId);
      if (document == null) {
        throw Exception('Document not found');
      }

      final updatedSharedCompanies = document.sharedCompanies
          .where((id) => id != companyId)
          .toList();

      final updatedDocument = document.copyWith(
        isSharedWithCompany: updatedSharedCompanies.isNotEmpty,
        sharedCompanies: updatedSharedCompanies,
        updatedAt: DateTime.now(),
      );

      await updateDocument(updatedDocument);
    } catch (e) {
      throw Exception('Failed to revoke document sharing: $e');
    }
  }

  @override
  Future<List<Document>> getDocumentsByType(String driverId, DocumentType type) async {
    try {
      final allDocuments = await getDocuments(driverId);
      return allDocuments.where((doc) => doc.type == type).toList();
    } catch (e) {
      throw Exception('Failed to load documents by type: $e');
    }
  }

  @override
  Future<List<Document>> searchDocuments(String driverId, String query) async {
    try {
      final allDocuments = await getDocuments(driverId);
      return allDocuments.where((doc) => 
          doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.description?.toLowerCase().contains(query.toLowerCase()) == true ||
          doc.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
      ).toList();
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }

  // Helper methods
  Document _mapToDocument(Map<String, dynamic> data) {
    return Document(
      id: data['id'],
      driverId: data['driver_id'],
      title: data['title'],
      type: DocumentType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => DocumentType.other,
      ),
      description: data['description'],
      filePath: data['file_path'],
      fileName: data['file_name'],
      fileSize: data['file_size'],
      mimeType: data['mime_type'],
      issueDate: data['issue_date'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(data['issue_date'])
          : null,
      expiryDate: data['expiry_date'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(data['expiry_date'])
          : null,
      status: DocumentStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => DocumentStatus.active,
      ),
      isSharedWithCompany: data['is_shared_with_company'] == 1,
      sharedCompanies: data['shared_companies']?.split(',') ?? [],
      tags: data['tags']?.split(',') ?? [],
      metadata: data['metadata'] != null 
          ? Map<String, dynamic>.from(data['metadata'])
          : {},
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updated_at']),
    );
  }

  Map<String, dynamic> _documentToMap(Document document) {
    return {
      'id': document.id,
      'driver_id': document.driverId,
      'title': document.title,
      'type': document.type.name,
      'description': document.description,
      'file_path': document.filePath,
      'file_name': document.fileName,
      'file_size': document.fileSize,
      'mime_type': document.mimeType,
      'issue_date': document.issueDate?.millisecondsSinceEpoch,
      'expiry_date': document.expiryDate?.millisecondsSinceEpoch,
      'status': document.status.name,
      'is_shared_with_company': document.isSharedWithCompany ? 1 : 0,
      'shared_companies': document.sharedCompanies.join(','),
      'tags': document.tags.join(','),
      'metadata': document.metadata.isNotEmpty ? document.metadata : null,
      'created_at': document.createdAt.millisecondsSinceEpoch,
      'updated_at': document.updatedAt.millisecondsSinceEpoch,
    };
  }
}