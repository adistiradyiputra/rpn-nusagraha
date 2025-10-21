import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/approval_history_models.dart';

class PdfViewerModal extends StatefulWidget {
  final ApprovalHistoryItem item;
  final String? serviceType;

  const PdfViewerModal({
    super.key,
    required this.item,
    this.serviceType,
  });

  @override
  State<PdfViewerModal> createState() => _PdfViewerModalState();
}

class _PdfViewerModalState extends State<PdfViewerModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? pdfPath;
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  String errorMessage = '';
  PDFViewController? pdfController;
  double zoomLevel = 1.0;
  TransformationController _transformationController = TransformationController();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Determine number of tabs based on service type
    final tabCount = _getTabCount();
    _tabController = TabController(length: tabCount, vsync: this);
    _loadPdfFromAssets();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Open the downloaded file when notification is tapped
    if (response.payload != null) {
      OpenFile.open(response.payload!);
    }
  }

  Future<void> _sendDownloadNotification(String fileName, String filePath) async {
    const androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Notifications for downloaded files',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      0, // notification id
      '📄 File Downloaded',
      'PDF file "$fileName" has been downloaded successfully. Tap to open.',
      notificationDetails,
      payload: filePath, // Pass file path as payload
    );
  }

  Future<void> _cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/tempt.pdf');
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final pdfData = await rootBundle.load('assets/tempt.pdf');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/tempt.pdf');
      await tempFile.writeAsBytes(pdfData.buffer.asUint8List());
      
      setState(() {
        pdfPath = tempFile.path;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading PDF: $e';
      });
    }
  }

  int _getTabCount() {
    // PR and PPAB have 3 tabs, others have 2 tabs
    if (widget.serviceType == 'pr' || widget.serviceType == 'ppab') {
      return 3;
    }
    return 2;
  }

  List<Tab> _buildTabs() {
    if (widget.serviceType == 'pr' || widget.serviceType == 'ppab') {
      // PR and PPAB have 3 tabs: PR, PPAB, Dokumen Pendukung
      return [
        Tab(
          icon: Icon(Icons.picture_as_pdf, size: 20),
          text: 'PR',
        ),
        Tab(
          icon: Icon(Icons.picture_as_pdf, size: 20),
          text: 'PPAB',
        ),
        Tab(
          icon: Icon(Icons.attach_file, size: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Dokumen'),
              Text('Pendukung'),
            ],
          ),
        ),
      ];
    } else {
      // Other services have 2 tabs: HPS, Dokumen Pendukung
      return [
        Tab(
          icon: Icon(Icons.picture_as_pdf, size: 20),
          text: widget.serviceType == 'hps' 
              ? 'HPS' 
              : widget.serviceType == 'pengadaan' 
                  ? 'Pengadaan' 
                  : 'PDF',
        ),
        Tab(
          icon: Icon(Icons.attach_file, size: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Dokumen'),
              Text('Pendukung'),
            ],
          ),
        ),
      ];
    }
  }

  List<Widget> _buildTabViews() {
    if (widget.serviceType == 'pr' || widget.serviceType == 'ppab') {
      // PR and PPAB have 3 tabs: PR, PPAB, Dokumen Pendukung
      return [
        _buildPdfSection('PR'),
        _buildPdfSection('PPAB'),
        _buildSupportingDocumentsSection(),
      ];
    } else {
      // Other services have 2 tabs: HPS, Dokumen Pendukung
      return [
        _buildPdfSection(
          widget.serviceType == 'hps' 
              ? 'HPS' 
              : widget.serviceType == 'pengadaan' 
                  ? 'Pengadaan' 
                  : 'PDF'
        ),
        _buildSupportingDocumentsSection(),
      ];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.dispose();
    _cleanupTempFiles(); // Clean up temporary files
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.navyBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'Dokumen ${widget.item.number}',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryBlue,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: Colors.grey,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              tabs: _buildTabs(),
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
              children: _buildTabViews(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfSection(String documentType) {
    return Column(
      children: [
        // PDF Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: AppSizes.md),
                IconButton(
                  onPressed: () {
                    // Show page navigation dialog
                    _showPageNavigationDialog();
                  },
                  icon: const Icon(Icons.menu, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Text('$currentPage / $totalPages', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () {
                    // Zoom out
                    if (zoomLevel > 0.5) {
                      setState(() {
                        zoomLevel -= 0.25;
                      });
                      _transformationController.value = Matrix4.identity()..scale(zoomLevel);
                    }
                  },
                  icon: const Icon(Icons.zoom_out, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  onPressed: () {
                    // Zoom in
                    if (zoomLevel < 3.0) {
                      setState(() {
                        zoomLevel += 0.25;
                      });
                      _transformationController.value = Matrix4.identity()..scale(zoomLevel);
                    }
                  },
                  icon: const Icon(Icons.zoom_in, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  onPressed: () {
                    // Download PDF
                    _downloadPdf();
                  },
                  icon: const Icon(Icons.download, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
        
        // PDF Document Preview
        Expanded(
          child: _buildPdfViewer(),
        ),
      ],
    );
  }

  Widget _buildPdfViewer() {
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Error Loading PDF',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              errorMessage,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (pdfPath == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      transformationController: _transformationController,
      onInteractionUpdate: (details) {
        setState(() {
          zoomLevel = details.scale;
        });
      },
      child: PDFView(
        filePath: pdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: currentPage,
        onRender: (pages) {
          setState(() {
            totalPages = pages ?? 0;
            isReady = true;
          });
        },
        onViewCreated: (PDFViewController controller) {
          pdfController = controller;
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            currentPage = page ?? 0;
          });
        },
        onError: (error) {
          setState(() {
            errorMessage = 'Error loading PDF: $error';
          });
        },
      ),
    );
  }

  void _showPageNavigationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Go to Page'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter page number (1-$totalPages)',
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final page = int.tryParse(value);
            if (page != null && page >= 1 && page <= totalPages) {
              pdfController?.setPage(page - 1);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _downloadPdf() async {
    if (pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF not available for download')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get the appropriate downloads directory based on platform
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        // For Android, use external storage downloads directory
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          // Fallback to app documents directory
          final appDir = await getApplicationDocumentsDirectory();
          downloadsDir = Directory('${appDir.path}/Downloads');
        }
      } else if (Platform.isIOS) {
        // For iOS, use app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        downloadsDir = Directory('${appDir.path}/Downloads');
      } else {
        // For other platforms, use app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        downloadsDir = Directory('${appDir.path}/Downloads');
      }
      
      // Create Downloads directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Generate filename with document number and timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cleanNumber = widget.item.number.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final fileName = '${cleanNumber}_$timestamp.pdf';
      final filePath = '${downloadsDir.path}/$fileName';

      // Copy file to downloads directory
      final sourceFile = File(pdfPath!);
      await sourceFile.copy(filePath);

      // Close loading dialog
      Navigator.of(context).pop();

      // Send notification
      await _sendDownloadNotification(fileName, filePath);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✅ PDF Downloaded Successfully!'),
              const SizedBox(height: 4),
              Text(
                'File: $fileName',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Location: ${downloadsDir.path}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Close loading dialog if it's open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('❌ Download Failed'),
              const SizedBox(height: 4),
              Text(
                'Error: $e',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  Widget _buildSupportingDocumentsSection() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Supporting Documents Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusMd),
                topRight: Radius.circular(AppSizes.radiusMd),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  size: 18,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: AppSizes.xs),
                const Text(
                  'Dokumen Pendukung',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Supporting Documents Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Document Preview
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'Dokumen Pendukung',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          'PDF / Gambar',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Document Info
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.description,
                              size: 16,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              'Dokumen Pendukung.pdf',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              '2.5 MB • 15 Jan 2025',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement document download
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('Download'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.sm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement document view
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('Lihat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38A169),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.sm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
