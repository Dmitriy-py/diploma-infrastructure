terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "diploma-tfstate-klimovdg"
    region = "ru-central1"
    key    = "network/terraform.tfstate" 

    # Эти параметры отключают проверки, специфичные для AWS, 
    # которые не работают с Yandex Cloud
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true 
  }
}