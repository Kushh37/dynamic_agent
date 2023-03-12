import 'dart:io';

abstract class BaseStorageProvider {
  Future<String> uploadPrescriptionImage({required File image});
  Future<String> uploadReportImage({required File image});
  Future<String> uploadPrescriptionBookingImage({required File image});
  Future<String> uploadPrescriptionCallImage({required File image});

  Future<String> uploadDoctorImage({required File image});
  Future<String> uploadPatientImage({required File image});
}
