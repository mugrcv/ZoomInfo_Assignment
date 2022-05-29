resource "aws_cloudwatch_dashboard" "main1" {
  dashboard_name = var.dashboard1_name
  dashboard_body = jsonencode({
    widgets = local.widgets
  })
}

locals {
  widgets = [for service_name in var.service1_names : {
    type   = "metric"
    width  = 18
    height = 6
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/ECS", "CPUUtilization", "ServiceName", service_name, "ClusterName", var.cluster_name1, { color = "#d62728", stat = "Maximum" }],
        [".", "MemoryUtilization", ".", ".", ".", ".", { yAxis = "right", color = "#1f77b4", stat = "Maximum" }]
      ]
      region = var.aws_region,
      annotations = {
        horizontal = [
          {
            color = "#ff9896",
            label = "100% CPU",
            value = 100
          },
          {
            color = "#9edae5",
            label = "100% Memory",
            value = 100,
            yAxis = "right"
          },
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = " var.cluster_name1/ ${service_name}"
      period = 300
    }
  }]
}


resource "aws_cloudwatch_dashboard" "main2" {
  dashboard_name = var.dashboard2_name
  dashboard_body = jsonencode({
    widgets = local.widgets1
  })
}

locals {
  widgets1 = [for service_name in var.service2_names : {
    type   = "metric"
    width  = 18
    height = 6
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/ECS", "CPUUtilization", "ServiceName", service_name, "ClusterName", var.cluster_name2, { color = "#d62728", stat = "Maximum" }],
        [".", "MemoryUtilization", ".", ".", ".", ".", { yAxis = "right", color = "#1f77b4", stat = "Maximum" }]
      ]
      region = var.aws_region,
      annotations = {
        horizontal = [
          {
            color = "#ff9896",
            label = "100% CPU",
            value = 100
          },
          {
            color = "#9edae5",
            label = "100% Memory",
            value = 100,
            yAxis = "right"
          },
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = " var.cluster_name2 / ${service_name}"
      period = 300
    }
  }]
}

