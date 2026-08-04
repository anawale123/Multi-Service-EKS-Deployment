data "aws_lb" "alb" {
  name = "k8s-ingressn-albfront-99323e80a0"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "url-shortener-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [

      # ALB REQUEST COUNT
      {
        type = "metric"
        properties = {
          title  = "ALB Request Count"
          region = "eu-west-2"
          period = 60
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", data.aws_lb.alb.arn_suffix]
          ]
        }
      },

      # ALB RESPONSE TIME
      {
        type = "metric"
        properties = {
          title  = "ALB Response Time"
          region = "eu-west-2"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", data.aws_lb.alb.arn_suffix]
          ]
        }
      },

      # ALB 5XX ERRORS
      {
        type = "metric"
        properties = {
          title  = "ALB 5XX Errors"
          region = "eu-west-2"
          period = 60
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", data.aws_lb.alb.arn_suffix]
          ]
        }
      },

      # SQS QUEUE DEPTH
      {
        type = "metric"
        properties = {
          title  = "SQS Queue Depth"
          region = "eu-west-2"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", var.sqs_queue_name],
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", var.dlq_queue_name]
          ]
        }
      },

      # RDS CPU
      {
        type = "metric"
        properties = {
          title  = "RDS CPU Utilization"
          region = "eu-west-2"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_identifier]
          ]
        }
      }
    ]
  })
}