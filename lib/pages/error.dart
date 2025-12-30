import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;
  final VoidCallback? onRetry;
  final String? customMessage;
  final String? buttonText;

  const ErrorPage({
    super.key,
    this.error,
    this.onRetry,
    this.customMessage,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка ошибки
                _buildErrorIcon(),
                
                const SizedBox(height: 24),
                
                // Заголовок
                _buildTitle(),
                
                const SizedBox(height: 16),
                
                // Сообщение об ошибке
                _buildErrorMessage(),
                
                const SizedBox(height: 32),
                
                // Кнопки действий
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.error_outline,
        size: 64,
        color: Colors.red,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _getTitle(),
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage() {
    final message = customMessage ?? _getErrorMessage();
    
    return Column(
      children: [
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        if (error != null) ...[
          const SizedBox(height: 16),
          _buildErrorDetails(),
        ],
      ],
    );
  }

  Widget _buildErrorDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error details:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            error.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Кнопка "Назад"
        if (context.canPop())
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Go Back'),
          ),
        
        if (context.canPop() && onRetry != null) 
          const SizedBox(width: 16),
        
        // Кнопка "Повторить" или "На главную"
        ElevatedButton(
          onPressed: onRetry ?? () => context.go('/'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            backgroundColor: Colors.blue,
          ),
          child: Text(
            buttonText ?? (onRetry != null ? 'Try Again' : 'Go Home'),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Вспомогательные методы
  String _getTitle() {
    if (customMessage != null) return 'Oops!';
    
    if (error != null) {
      final errorStr = error.toString().toLowerCase();
      
      if (errorStr.contains('network') || errorStr.contains('connection')) {
        return 'No Internet Connection';
      } else if (errorStr.contains('timeout')) {
        return 'Request Timeout';
      } else if (errorStr.contains('404') || errorStr.contains('not found')) {
        return 'Page Not Found';
      } else if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
        return 'Access Denied';
      } else if (errorStr.contains('500') || errorStr.contains('server')) {
        return 'Server Error';
      }
    }
    
    return 'Something Went Wrong';
  }

  String _getErrorMessage() {
    if (error != null) {
      final errorStr = error.toString().toLowerCase();
      
      if (errorStr.contains('network') || errorStr.contains('connection')) {
        return 'Please check your internet connection and try again.';
      } else if (errorStr.contains('timeout')) {
        return 'The request took too long. Please try again.';
      } else if (errorStr.contains('404') || errorStr.contains('not found')) {
        return 'The page you are looking for doesn\'t exist.';
      } else if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
        return 'You don\'t have permission to access this page.';
      } else if (errorStr.contains('500') || errorStr.contains('server')) {
        return 'Our servers are having issues. Please try again later.';
      }
    }
    
    return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
  }
}

// Различные типы страниц ошибок
class NetworkErrorPage extends StatelessWidget {
  final VoidCallback onRetry;
  
  const NetworkErrorPage({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      customMessage: 'No internet connection',
      buttonText: 'Retry',
      onRetry: onRetry,
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      customMessage: 'The page you\'re looking for doesn\'t exist',
      buttonText: 'Go Home',
    );
  }
}

class ServerErrorPage extends StatelessWidget {
  final VoidCallback onRetry;
  
  const ServerErrorPage({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      customMessage: 'Server is temporarily unavailable',
      buttonText: 'Try Again',
      onRetry: onRetry,
    );
  }
}

// Утилита для показа ошибок
class ErrorUtils {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showNetworkErrorDialog(BuildContext context, VoidCallback onRetry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}