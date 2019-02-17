resource "aws_route53_zone" "dns_zone" {
  name = "${var.dns_zone}"
}

# data "aws_route53_zone" "dns_zone" {
#  # name = "${var.dns_zone}."
#  name = "${var.dns_zone}"
# }

resource "aws_route53_record" "gmail_mx" {
  zone_id = "${aws_route53_zone.dns_zone.zone_id}"
  type    = "MX"
  name    = ""
  ttl = 3600

  records = ["1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]
}

variable "gsuite_cnames" {
  default = ["mail", "cal", "docs"]
}

resource "aws_route53_record" "gsuite_cnames" {
  count   = "${length(var.gsuite_cnames)}"
  zone_id = "${aws_route53_zone.dns_zone.zone_id}"
  name    = "${element(var.gsuite_cnames, count.index)}"
  type    = "CNAME"
  records = ["ghs.googlehosted.com"]
  ttl     = 3600
}
