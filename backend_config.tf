terraform{
         backend "s3"{
                bucket="stackbuckstate-sheff"
                key = "terraform.tfstate"
                region="us-east-1"
                dynamodb_table="statelock-tf"
                }
 }