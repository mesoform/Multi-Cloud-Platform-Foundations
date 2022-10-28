"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)


"""
    Checks the data specified in the required metadata
"""

expected_data = {
    "A_records" : "1",
    "AAAA_records" : "0",
    "ALIAS_records" : "0",
    "CAA_records" : "0",
    "CNAME_records" : "3",
    "DNSKEY_records" : "0",
    "DS_records" : "0",
    "HTTPS_records" : "0",
    "IPSECKEY_records" : "0",
    "MX_records" : "1",
    "NAPTR_records" : "0",
    "PTR_records" : "0",
    "SOA_records" : "0",
    "SPF_records" : "0",
    "SRV_records" : "0",
    "SSHFP_records" : "0",
    "SVCB_records" : "0",
    "TLSA_records" : "0",
    "TXT_records" : "0"
}
# expected_data = {
#     "A_records": 1,
#     "CNAME_records": 1,
#     "MX_records": 0
# }

if __name__ == '__main__':
    python_validator(expected_data)
