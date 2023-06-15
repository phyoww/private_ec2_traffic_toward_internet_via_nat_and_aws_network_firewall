resource "aws_networkfirewall_firewall_policy" "cloudideastar-firewall-policy" {
  name = "cloudideastar-aws-network-firewall-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
#    stateless_rule_group_reference {
#      priority     = 20
#      resource_arn = aws_networkfirewall_rule_group.allow-local.arn
#    }

    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.drop_icmp_traffic_fw_rule_group.arn
    }

    stateless_rule_group_reference {
      priority     = 2
      resource_arn = aws_networkfirewall_rule_group.pass_ssh_traffic_fw_rule_group.arn
    }    

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.deny-http.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.deny-https-domains.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.deny-ssh.arn
    }
  }
}
resource "aws_networkfirewall_firewall" "NFW" {
  firewall_policy_arn = aws_networkfirewall_firewall_policy.cloudideastar-firewall-policy.arn
  name                = var.firewall-name
  vpc_id              = aws_vpc.vpc.id
  subnet_mapping {
    subnet_id = aws_subnet.cloudideastar_firewall_subnet.id
  }
  tags = {
    Name = "Cloudideastar-aws-network-firewall"
  }
#  depends_on = [aws_vpc.cloudideastar_custom_vpc.id]
}
