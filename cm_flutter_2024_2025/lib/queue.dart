import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:cm_flutter_2024_2025/secrets.dart';
import 'package:flutter/material.dart';

final sqs = SQS(
    region: AWS_REGION,
    credentials: AwsClientCredentials(
        accessKey: AWS_SQS_ACCESS_KEY, secretKey: AWS_SQS_SECRET_KEY));

Future<String?> subscribeToTopic() async {
  try {
    var response = await sqs.receiveMessage(queueUrl: QUEUE_URL);
    var str = '';
    if (response.messages != null) {
      for (var message in response.messages!) {
        str += message.body!;

        // Delete the message after processing
        await sqs.deleteMessage(
          queueUrl: QUEUE_URL,
          receiptHandle: message.receiptHandle!,
        );
      }
    }
    sqs.sendMessage(
        messageBody: 'message from flutter2',
        messageGroupId: 'flutter',
        queueUrl: QUEUE_URL);
    debugPrint('Response: $str');
    return str;
  } catch (e) {
    debugPrint('Failed to subscribe: $e');
    return null;
  }
}
