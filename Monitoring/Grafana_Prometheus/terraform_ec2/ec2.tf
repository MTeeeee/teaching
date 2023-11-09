module "ec2_module" {
  source = "./modules/ec2"

  vpc_id     = module.vpc_module.vpc_id
  subnet_ids = module.vpc_module.subnet_ids
}