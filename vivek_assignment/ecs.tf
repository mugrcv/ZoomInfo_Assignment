module "s1-ecs" {
  source             = "../vivek_assignment/modules/ecs/"
  name               = "service1"
}


module "ecs-s1" {
  source             = "../vivek_assignment/modules/ecs-service/"
  container_name     = "service1"
  ecs_id             = module.s1-ecs.cluster_id
  ecs_security_group = aws_security_group.service-sg.id
  ecs_subnet         = aws_subnet.private_subnet[0].id
  image              = var.service1_image
  tg_arn             = module.s1-tg[0].pub-tg-arn
  depends_on         = [module.pri-lb, module.pub-lb, module.s1-tg, aws_vpc_endpoint.ecr-api-endpoint, aws_vpc_endpoint.ecr-dkr-endpoint, aws_vpc_endpoint.s3-gateway-endpoint, module.s1-ecs]
}

module  "s2-ecs" {
  source             = "../vivek_assignment/modules/ecs/"
  name               = "service2"
}


module "ecs-s2" {
  source             = "../vivek_assignment/modules/ecs-service/"
  container_name     = "service2"
  ecs_id             = module.s2-ecs.cluster_id
  ecs_security_group = aws_security_group.service-sg.id
  ecs_subnet         = aws_subnet.private_subnet[0].id
  image              = var.service2_image
  tg_arn             = module.s1-tg[1].pub-tg-arn
  depends_on         = [module.pri-lb, module.pub-lb, module.s1-tg, aws_vpc_endpoint.ecr-api-endpoint, aws_vpc_endpoint.ecr-dkr-endpoint, aws_vpc_endpoint.s3-gateway-endpoint,module.s1-ecs]
}

##### Auto scaling policy ####

###service-one scaling###

resource "aws_appautoscaling_target" "app_scale_target_service1" {
  service_namespace  = "ecs"
  resource_id        = "service/service1/service1_service"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}



resource "aws_cloudwatch_metric_alarm" "scale_out_service1" {
  alarm_name          = "scale_out_service1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "100"

 dimensions = {
        LoadBalancer = module.pub-lb.pub_alb_arn_suffix
      }

  alarm_actions = [aws_appautoscaling_policy.app_up_service1.arn]
}

resource "aws_appautoscaling_policy" "app_up_service1" {
  name               = "app-scale-up-service1"
  service_namespace  = aws_appautoscaling_target.app_scale_target_service1.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target_service1.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target_service1.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "scale_in_service1" {
  alarm_name                = "scale_in_service1"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "10"
  threshold                 = "1"
  alarm_description         = "scale_in_service1"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "IF((m1<50 AND m2>1),2,1)"
    label       = "scale_in"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
       LoadBalancer = module.pub-lb.pub_alb_arn_suffix
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "RunningTaskCount"
      namespace   = "ECS/ContainerInsights"
      period      = "120"
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        ClusterName = "service1"
	ServiceName = "service1_service"
      }
    }
  }

 alarm_actions = [aws_appautoscaling_policy.app_down_service1.arn]
}




resource "aws_appautoscaling_policy" "app_down_service1" {
  name               = "app-scale-down-service1"
  service_namespace  = aws_appautoscaling_target.app_scale_target_service1.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target_service1.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target_service1.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

###service-two scaling###

resource "aws_appautoscaling_target" "app_scale_target_service2" {
  service_namespace  = "ecs"
  resource_id        = "service/service2/service2_service"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}



resource "aws_cloudwatch_metric_alarm" "scale_out_service2" {
  alarm_name          = "scale_out_service2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "100"

 dimensions = {
        LoadBalancer = module.pub-lb.pub_alb_arn_suffix
      }

  alarm_actions = [aws_appautoscaling_policy.app_up_service2.arn]
}

resource "aws_appautoscaling_policy" "app_up_service2" {
  name               = "app-scale-up-service2"
  service_namespace  = aws_appautoscaling_target.app_scale_target_service2.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target_service2.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target_service2.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "scale_in_service2" {
  alarm_name                = "scale_in_service2"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "10"
  threshold                 = "1"
  alarm_description         = "scale_in_service2"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "IF((m1<50 AND m2>1),2,1)"
    label       = "scale_in"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
       LoadBalancer = module.pub-lb.pub_alb_arn_suffix
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "RunningTaskCount"
      namespace   = "ECS/ContainerInsights"
      period      = "120"
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        ClusterName = "service2"
        ServiceName = "service2_service"
      }
    }
  }

 alarm_actions = [aws_appautoscaling_policy.app_down_service2.arn]
}



resource "aws_appautoscaling_policy" "app_down_service2" {
  name               = "app-scale-down-service2"
  service_namespace  = aws_appautoscaling_target.app_scale_target_service2.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target_service2.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target_service2.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}




