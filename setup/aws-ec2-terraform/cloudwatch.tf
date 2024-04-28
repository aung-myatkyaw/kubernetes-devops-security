resource "aws_cloudwatch_dashboard" "main" {
  provider       = aws.mumbai
  dashboard_name = "DevSecOps-Jenkins"
  dashboard_body = jsonencode(
    {
      widgets = [
        {
          height = 6
          properties = {
            legend = {
              position = "bottom"
            }
            liveData = false
            metrics = [
              [
                "AWS/EC2",
                "CPUUtilization",
                "InstanceId",
                data.aws_instance.devsecops_staging.id
              ],
            ]
            period   = 60
            region   = data.aws_region.current.name
            stacked  = true
            stat     = "Average"
            timezone = "+0630"
            title    = "DevSecOps-Jenkins's CPU Utilization Graph"
            view     = "timeSeries"
          }
          type  = "metric"
          width = 8
          x     = 0
          y     = 0
        },
        {
          height = 6
          properties = {
            metrics = [
              [
                "CWAgent",
                "mem_used_percent",
                "InstanceId",
                data.aws_instance.devsecops_staging.id,
                {
                  color = "#ff7f0e"
                },
              ],
            ]
            period   = 60
            region   = data.aws_region.current.name
            stacked  = true
            stat     = "Average"
            timezone = "+0630"
            title    = "DevSecOps-Jenkins's Memory Usage Percent"
            view     = "timeSeries"
          }
          type  = "metric"
          width = 8
          x     = 8
          y     = 0
        },
        {
          height = 6
          properties = {
            metrics = [
              [
                "CWAgent",
                "disk_used_percent",
                "InstanceId",
                data.aws_instance.devsecops_staging.id,
                {
                  color = "#2ca02c"
                },
              ],
            ]
            period   = 300
            region   = data.aws_region.current.name
            stacked  = true
            stat     = "Average"
            timezone = "+0630"
            title    = "DevSecOps-Jenkins's Disk Usage Percent"
            view     = "timeSeries"
          }
          type  = "metric"
          width = 8
          x     = 16
          y     = 0
        },
        {
          height = 6
          properties = {
            metrics = [
              [
                "AWS/EC2",
                "CPUCreditBalance",
                "InstanceId",
                data.aws_instance.devsecops_staging.id,
                {
                  color = "#17becf"
                },
              ],
            ]
            period    = 300
            region    = data.aws_region.current.name
            sparkline = true
            stacked   = true
            stat      = "Average"
            timezone  = "+0630"
            title     = "DevSecOps-Jenkins's CPU Credit Balance"
            view      = "timeSeries"
          }
          type  = "metric"
          width = 8
          x     = 0
          y     = 6
        },
        # {
        #   height = 6
        #   properties = {
        #     metrics = [
        #       [
        #         "AWS/RDS",
        #         "CPUUtilization",
        #         "DBInstanceIdentifier",
        #         aws_db_instance.devsecops_db_instance.identifier
        #       ],
        #     ]
        #     period    = 60
        #     region    = data.aws_region.current.name
        #     sparkline = true
        #     stacked   = true
        #     stat      = "Average"
        #     timezone  = "+0630"
        #     title     = "RDS CPU Utilization Graph"
        #     view      = "timeSeries"
        #   }
        #   type  = "metric"
        #   width = 8
        #   x     = 8
        #   y     = 6
        # },
        # {
        #   height = 6
        #   properties = {
        #     metrics = [
        #       [
        #         "AWS/RDS",
        #         "CPUCreditBalance",
        #         "DBInstanceIdentifier",
        #         aws_db_instance.devsecops_db_instance.identifier,
        #         {
        #           color = "#17becf"
        #         },
        #       ],
        #     ]
        #     period    = 300
        #     region    = data.aws_region.current.name
        #     sparkline = true
        #     stacked   = true
        #     stat      = "Average"
        #     timezone  = "+0630"
        #     title     = "RDS CPU Credit Balance"
        #     view      = "timeSeries"
        #   }
        #   type  = "metric"
        #   width = 8
        #   x     = 16
        #   y     = 6
        # }
      ]
    }
  )
}
