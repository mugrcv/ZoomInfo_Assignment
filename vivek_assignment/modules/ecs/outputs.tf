output "name" {
  description = "Cluster name"
  value       = concat(aws_ecs_cluster.this.*.name, [""])[0]
}


output "cluster_id" {
  description = "Cluster name"
  value       = concat(aws_ecs_cluster.this.*.id, [""])[0]
}

