/**

**/

# Image for writer lambda
module "simple_log_service_ecr_write_image" {
    source = "./modules/ecr"
    ecr_name = "${var.product_name}-writer-ecr"  
}

# Image for reader lambda
module "simple_log_service_ecr_read_image" {
    source = "./modules/ecr"
    ecr_name = "${var.product_name}-reader-ecr"
}