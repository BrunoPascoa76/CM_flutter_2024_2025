import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:cm_flutter_2024_2025/secrets.dart';
import 'package:flutter/material.dart';

final sqs = SQS(
    region: AWS_REGION,
    credentials: AwsClientCredentials(
        accessKey: AWS_SQS_ACCESS_KEY, secretKey: AWS_SQS_SECRET_KEY));

Future<Message?> poolDeliveryMessage() async {
  try {
    var response =
        await sqs.receiveMessage(queueUrl: QUEUE_URL, maxNumberOfMessages: 1);

    return response.messages?.first;
  } catch (e) {
    debugPrint('There is no new message: $e');
    return null;
  }
}

Future<void> deleteMessageFromQueue(String receiptHandle) async {
  sqs.deleteMessage(
    queueUrl: QUEUE_URL,
    receiptHandle: receiptHandle,
  );
}
