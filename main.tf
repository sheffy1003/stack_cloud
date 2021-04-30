/*
module "clixxapp" {
    source    = "./modules/clixxapp"
    AWS_REGION = var.AWS_REGION
    PATH_TO_PRIVATE_KEY=var.PATH_TO_PRIVATE_KEY
    PATH_TO_PUBLIC_KEY=var.PATH_TO_PUBLIC_KEY
    AMIS=var.AMIS
    DATABASE_USER=var.DATABASE_USER
    DATABASE_PASSWORD=var.DATABASE_PASSWORD
    RDS_ENDPOINT=var.RDS_ENDPOINT
    DATABASE_NAME=var.DATABASE_NAME
    AWS_SECRET_KEY=var.AWS_SECRET_KEY
    AWS_ACCESS_KEY=var.AWS_ACCESS_KEY

}*/


module "clixxebs" {
    source    ="github.com/sheffy1003/stack_cloud.git?ref=stack_modules/clixxebs"
    AWS_REGION = var.AWS_REGION
    PATH_TO_PRIVATE_KEY=var.PATH_TO_PRIVATE_KEY
    PATH_TO_PUBLIC_KEY=var.PATH_TO_PUBLIC_KEY
    AMIS=var.AMIS
    ebs_name=var.ebs_name
    mysubnet_id=var.mysubnet_id
    AZ_ZONE=var.AZ_ZONE
    DATABASE_USER=var.DATABASE_USER
    DATABASE_PASSWORD=var.DATABASE_PASSWORD
    RDS_ENDPOINT=var.RDS_ENDPOINT
    DATABASE_NAME=var.DATABASE_NAME
    AWS_SECRET_KEY=var.AWS_SECRET_KEY
    AWS_ACCESS_KEY=var.AWS_ACCESS_KEY
    
}


/*
source="github.com/sheffy1003/stack_cloud.git?ref=stack_modules/clixxebs"*/