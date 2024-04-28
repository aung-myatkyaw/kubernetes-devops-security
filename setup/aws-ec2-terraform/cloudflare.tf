# For Account ID
data "cloudflare_accounts" "aungmyatkyaw" {
  name = "aungmyatkyaw"
}

# zone
data "cloudflare_zone" "aungmyatkyaw_site" {
  account_id = data.cloudflare_accounts.aungmyatkyaw.accounts.0.id
  name       = var.cloudflare_website_name
}

resource "cloudflare_record" "jenkins" {
  name            = "jenkins"
  proxied         = true
  ttl             = 1
  type            = "A"
  value           = aws_eip.devsecops_ip.public_ip
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.aungmyatkyaw_site.id
}

resource "cloudflare_record" "sonarqube" {
  name            = "sonarqube"
  proxied         = true
  ttl             = 1
  type            = "A"
  allow_overwrite = true
  value           = aws_eip.devsecops_ip.public_ip
  zone_id         = data.cloudflare_zone.aungmyatkyaw_site.id
}

resource "cloudflare_record" "devsecops" {
  name            = "devsecops"
  proxied         = true
  ttl             = 1
  type            = "CNAME"
  allow_overwrite = true
  value           = aws_lb.devsecops_jenkins_nlb.dns_name
  zone_id         = data.cloudflare_zone.aungmyatkyaw_site.id
}

resource "cloudflare_record" "numeric" {
  name            = "numeric"
  proxied         = true
  ttl             = 1
  type            = "CNAME"
  allow_overwrite = true
  value           = aws_lb.devsecops_jenkins_nlb.dns_name
  zone_id         = data.cloudflare_zone.aungmyatkyaw_site.id
}
