// Notification Topic
data "aws_sns_topic" "notification_topic" {
  provider = aws.mumbai
  name     = "mumbai-sns-topic-${data.aws_region.current.name}"
}
