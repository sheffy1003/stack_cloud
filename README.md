# stack_cloud
stackIT cloud project

This Project was carried out to design and implement a well archictected custom VPC for a PHP based application in line with AWS best practices. The build, testing and deployment of the application is triggered by webhook in github repository. Jenkins CI/CD pipeline created for this project is then integrated with Terraform to execute the code.

Some of the resources deployed in this VPC project include:
1. Application Load Balancer: To manage traffic going to autoscale group.
2. hosted domain name(Route53) using simple based routing ( resolves domain name to alias record of load balancer.
3. Application server deployed in an autoscale group to meet peak demand and higher availability.
4. Four Private and Four public subnets in 2 availability zones.
5. Bastion host in public subnet: Manage server administration in private subnets.
6. NAT Gateway: Provides egress connection for server in private subnets.
7. Security Groups
8. RDS MySQL Database: Restored from a database snapshot and deployed into a private subnet for extra security
9. DB Subnet Group
10. Internet Gateway

Note: For data security: the terraform state file and aws credentials is not pushed to the repo directly.
