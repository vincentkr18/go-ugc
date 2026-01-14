/// Model for video generation job response
class VideoGenerationJob {
  final String jobId;
  final String status;
  final String model;
  final int progress;
  final String createdAt;
  final String message;
  final String? videoGeneratedPath;
  
  VideoGenerationJob({
    required this.jobId,
    required this.status,
    required this.model,
    required this.progress,
    required this.createdAt,
    required this.message,
    this.videoGeneratedPath,
  });
  
  factory VideoGenerationJob.fromJson(Map<String, dynamic> json) {
    return VideoGenerationJob(
      jobId: json['job_id'] as String,
      status: json['status'] as String,
      model: json['model'] as String,
      progress: json['progress'] as int,
      createdAt: json['created_at'] as String,
      message: json['message'] as String,
      videoGeneratedPath: json['video_generated_path'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'status': status,
      'model': model,
      'progress': progress,
      'created_at': createdAt,
      'message': message,
      'video_generated_path': videoGeneratedPath,
    };
  }
  
  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
}
