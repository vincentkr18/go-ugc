import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_auth_details.dart';
import '../services/user_api_service.dart';
import '../theme/app_theme.dart';

/// Widget to display user authentication details fetched from the API
class UserAuthDetailsCard extends StatefulWidget {
  const UserAuthDetailsCard({super.key});

  @override
  State<UserAuthDetailsCard> createState() => _UserAuthDetailsCardState();
}

class _UserAuthDetailsCardState extends State<UserAuthDetailsCard> {
  final UserApiService _apiService = UserApiService();
  
  bool _isLoading = true;
  String? _errorMessage;
  UserAuthDetails? _userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserAuthDetails();
  }

  Future<void> _fetchUserAuthDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getUserAuthDetails();
      setState(() {
        _userDetails = UserAuthDetails.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('MMM dd, yyyy HH:mm').format(date.toLocal());
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Authentication Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (!_isLoading)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _fetchUserAuthDetails,
                  tooltip: 'Refresh',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          
          if (_isLoading)
            _buildLoadingState()
          else if (_errorMessage != null)
            _buildErrorState()
          else if (_userDetails != null)
            _buildDetailsContent(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentTeal),
            ),
            SizedBox(height: AppTheme.spacingMd),
            Text(
              'Loading authentication details...',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error occurred',
            style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _fetchUserAuthDetails,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent() {
    final details = _userDetails!;
    
    return Column(
      children: [
        _buildDetailRow(
          icon: Icons.fingerprint,
          label: 'User ID',
          value: details.id,
          isId: true,
        ),
        _buildDetailRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: details.email ?? 'N/A',
        ),
        _buildDetailRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: details.phone ?? 'Not provided',
        ),
        _buildDetailRow(
          icon: Icons.verified_user_outlined,
          label: 'Email Verified',
          value: details.emailConfirmedAt != null ? 'Yes' : 'No',
          valueColor: details.emailConfirmedAt != null 
              ? Colors.green.shade700 
              : Colors.orange.shade700,
        ),
        _buildDetailRow(
          icon: Icons.shield_outlined,
          label: 'Role',
          value: details.role ?? 'N/A',
        ),
        _buildDetailRow(
          icon: Icons.access_time,
          label: 'Last Sign In',
          value: _formatDateTime(details.lastSignInAt),
        ),
        _buildDetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'Account Created',
          value: _formatDateTime(details.createdAt),
        ),
        
        if (details.identities != null && details.identities!.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Connected Providers',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...details.identities!.map((identity) => _buildProviderChip(identity)),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isId = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppTheme.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppTheme.accentTeal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isId && value.length > 20 
                      ? '${value.substring(0, 20)}...' 
                      : value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderChip(UserIdentity identity) {
    IconData providerIcon;
    Color providerColor;
    
    switch (identity.provider?.toLowerCase()) {
      case 'google':
        providerIcon = Icons.g_mobiledata;
        providerColor = Colors.red;
        break;
      case 'facebook':
        providerIcon = Icons.facebook;
        providerColor = Colors.blue;
        break;
      case 'github':
        providerIcon = Icons.code;
        providerColor = Colors.black;
        break;
      default:
        providerIcon = Icons.account_circle;
        providerColor = AppTheme.accentTeal;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: providerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: providerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(providerIcon, size: 20, color: providerColor),
          const SizedBox(width: 8),
          Text(
            identity.provider?.toUpperCase() ?? 'UNKNOWN',
            style: TextStyle(
              color: providerColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            'Connected ${_formatDateTime(identity.createdAt)}',
            style: TextStyle(
              color: providerColor.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
