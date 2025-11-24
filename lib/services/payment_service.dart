import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../core/environment/env_config.dart';
import '../data/api/base_api_client.dart';
import '../domain/entities/booking.dart';

enum PaymentMethod {
  card, // 신용카드
  bankTransfer, // 계좌이체
  virtualAccount, // 가상계좌
  phone, // 휴대폰 소액결제
  kakaoPay, // 카카오페이
  naverPay, // 네이버페이
  payco, // 페이코
}

enum PaymentStatus {
  pending, // 결제 대기
  paid, // 결제 완료
  failed, // 결제 실패
  cancelled, // 결제 취소
  refunded, // 환불됨
}

class PaymentService {
  static const String _iamportBaseUrl = 'https://api.iamport.kr';

  // 결제 요청
  static Future<PaymentResult> requestPayment({
    required BuildContext context,
    required String merchantUid,
    required String name,
    required int amount,
    required String buyerName,
    required String buyerEmail,
    required String buyerTel,
    PaymentMethod method = PaymentMethod.card,
    Map<String, dynamic>? customData,
  }) async {
    try {
      // 결제 토큰 발급
      final token = await _getIamportToken();

      // 결제 정보 생성
      final paymentData = {
        'merchant_uid': merchantUid,
        'name': name,
        'amount': amount,
        'buyer_name': buyerName,
        'buyer_email': buyerEmail,
        'buyer_tel': buyerTel,
        'pay_method': _getPaymentMethodString(method),
        'custom_data': customData,
      };

      // 실제 결제 요청 (웹뷰 또는 네이티브 SDK 사용)
      // 여기서는 시뮬레이션
      final result = await _simulatePayment(paymentData);

      return result;
    } catch (e) {
      return PaymentResult(
        success: false,
        message: '결제 요청 실패: $e',
      );
    }
  }

  // 아임포트 토큰 발급
  static Future<String> _getIamportToken() async {
    try {
      final response = await http.post(
        Uri.parse('$_iamportBaseUrl/users/getToken'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'imp_key': EnvConfig.iamportApiKey,
          'imp_secret': EnvConfig.iamportApiSecret,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response']['access_token'];
      } else {
        throw Exception('토큰 발급 실패');
      }
    } catch (e) {
      throw Exception('아임포트 토큰 발급 실패: $e');
    }
  }

  // 결제 상태 조회
  static Future<PaymentStatus> getPaymentStatus(String impUid) async {
    try {
      final token = await _getIamportToken();

      final response = await http.get(
        Uri.parse('$_iamportBaseUrl/payments/$impUid'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final status = data['response']['status'];

        return _parsePaymentStatus(status);
      } else {
        throw Exception('결제 상태 조회 실패');
      }
    } catch (e) {
      print('결제 상태 조회 오류: $e');
      return PaymentStatus.failed;
    }
  }

  // 결제 취소
  static Future<bool> cancelPayment({
    required String impUid,
    required String reason,
    int? amount,
    String? checksum,
  }) async {
    try {
      final token = await _getIamportToken();

      final requestData = {
        'imp_uid': impUid,
        'reason': reason,
        if (amount != null) 'amount': amount,
        if (checksum != null) 'checksum': checksum,
      };

      final response = await http.post(
        Uri.parse('$_iamportBaseUrl/payments/cancel'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('결제 취소 오류: $e');
      return false;
    }
  }

  // 환불 요청
  static Future<bool> requestRefund({
    required String impUid,
    required String reason,
    int? amount,
  }) async {
    return cancelPayment(
      impUid: impUid,
      reason: reason,
      amount: amount,
    );
  }

  // 결제 검증
  static Future<bool> verifyPayment({
    required String impUid,
    required String merchantUid,
    required int expectedAmount,
  }) async {
    try {
      final status = await getPaymentStatus(impUid);
      if (status != PaymentStatus.paid) {
        return false;
      }

      // 금액 검증 등 추가 로직
      final token = await _getIamportToken();
      final response = await http.get(
        Uri.parse('$_iamportBaseUrl/payments/$impUid'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final actualAmount = data['response']['amount'];

        return actualAmount == expectedAmount;
      }

      return false;
    } catch (e) {
      print('결제 검증 오류: $e');
      return false;
    }
  }

  // 부트페이 결제 (대안 결제 수단)
  static Future<PaymentResult> requestBootpayPayment({
    required String applicationId,
    required String pg,
    required String method,
    required String name,
    required int price,
    required String orderId,
    Map<String, dynamic>? metadata,
  }) async {
    // 부트페이 SDK 통합
    // 실제 구현 시 부트페이 SDK 사용
    return PaymentResult(
      success: true,
      message: '부트페이 결제 시뮬레이션 성공',
      transactionId: orderId,
    );
  }

  // 결제 방법 문자열 변환
  static String _getPaymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.bankTransfer:
        return 'trans';
      case PaymentMethod.virtualAccount:
        return 'vbank';
      case PaymentMethod.phone:
        return 'phone';
      case PaymentMethod.kakaoPay:
        return 'kakaopay';
      case PaymentMethod.naverPay:
        return 'naverpay';
      case PaymentMethod.payco:
        return 'payco';
      default:
        return 'card';
    }
  }

  // 결제 상태 파싱
  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status) {
      case 'paid':
        return PaymentStatus.paid;
      case 'ready':
        return PaymentStatus.pending;
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }

  // 결제 시뮬레이션 (실제 앱에서는 제거)
  static Future<PaymentResult> _simulatePayment(Map<String, dynamic> paymentData) async {
    await Future.delayed(const Duration(seconds: 2)); // 결제 처리 시간 시뮬레이션

    // 90% 성공률로 시뮬레이션
    final success = DateTime.now().millisecond % 10 != 0;

    return PaymentResult(
      success: success,
      message: success ? '결제가 성공적으로 완료되었습니다.' : '결제 처리 중 오류가 발생했습니다.',
      transactionId: success ? 'imp_${DateTime.now().millisecondsSinceEpoch}' : null,
      paymentData: success ? paymentData : null,
    );
  }
}

// 결제 결과
class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;
  final Map<String, dynamic>? paymentData;

  PaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
    this.paymentData,
  });
}

// 결제 정보 클래스
class PaymentInfo {
  final String id;
  final PaymentMethod method;
  final PaymentStatus status;
  final int amount;
  final String currency;
  final DateTime createdAt;
  final String? transactionId;
  final String? failureReason;

  PaymentInfo({
    required this.id,
    required this.method,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.transactionId,
    this.failureReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method.name,
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'transaction_id': transactionId,
      'failure_reason': failureReason,
    };
  }

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id'],
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == json['method'],
        orElse: () => PaymentMethod.card,
      ),
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      amount: json['amount'],
      currency: json['currency'],
      createdAt: DateTime.parse(json['created_at']),
      transactionId: json['transaction_id'],
      failureReason: json['failure_reason'],
    );
  }
}

// 결제 위젯 (간단한 결제 폼)
class PaymentWidget extends StatefulWidget {
  final String itemName;
  final int amount;
  final String currency;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailed;

  const PaymentWidget({
    super.key,
    required this.itemName,
    required this.amount,
    this.currency = 'KRW',
    this.onPaymentSuccess,
    this.onPaymentFailed,
  });

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  PaymentMethod _selectedMethod = PaymentMethod.card;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 결제 정보
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                widget.itemName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.amount.toString()} ${widget.currency}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 결제 방법 선택
        const Text(
          '결제 방법',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        _buildPaymentMethodSelector(),

        const SizedBox(height: 32),

        // 결제 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    '결제하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: PaymentMethod.values.map((method) {
        return RadioListTile<PaymentMethod>(
          title: Text(_getPaymentMethodName(method)),
          value: method,
          groupValue: _selectedMethod,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedMethod = value);
            }
          },
          activeColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return '신용카드';
      case PaymentMethod.bankTransfer:
        return '계좌이체';
      case PaymentMethod.virtualAccount:
        return '가상계좌';
      case PaymentMethod.phone:
        return '휴대폰 소액결제';
      case PaymentMethod.kakaoPay:
        return '카카오페이';
      case PaymentMethod.naverPay:
        return '네이버페이';
      case PaymentMethod.payco:
        return '페이코';
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      final result = await PaymentService.requestPayment(
        context: context,
        merchantUid: 'merchant_${DateTime.now().millisecondsSinceEpoch}',
        name: widget.itemName,
        amount: widget.amount,
        buyerName: '테스트 사용자',
        buyerEmail: 'test@example.com',
        buyerTel: '010-1234-5678',
        method: _selectedMethod,
      );

      if (result.success) {
        widget.onPaymentSuccess?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message)),
          );
        }
      } else {
        widget.onPaymentFailed?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message)),
          );
        }
      }
    } catch (e) {
      widget.onPaymentFailed?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('결제 처리 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
