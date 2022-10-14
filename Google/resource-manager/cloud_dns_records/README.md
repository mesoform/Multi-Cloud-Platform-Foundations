# Cloud DNS Record Set
This module manages the Cloud DNS record set for a Google DNS managed zone.  
The types of record sets that can be managed are listed in the Google DNS [documentation](https://cloud.google.com/dns/docs/records#record_type).
Note: this module does not manage NS records.

## Configuration
Specify the location of the configuration file in the `cloud_dns_yml` variable.
The `components.specs` block contains a map of records for a specified google managed zone. 
Each zone has maps for a specified record type. E.g:  
```yaml
components:
  common:
    project_id: Project ID which resources belong 
  specs:
    private-zone:
      A_records: # A configuration
      AAAA_records: # AAAA configuration
      ALIAS_records: # ALIAS configuration
      CAA_records: # CAA configuration
      CNAME_records: # CNAME configuration
      DNSKEY_records: # DNSKEY configuration
      DS_records: # DS configuration
      HTTPS_records: # HTTPS configuration
      IPSECKEY_records: # IPSECKEY configuration
      MX_records: # MX configuration
      NAPTR_records: # NAPTR configuration
      PTR_records: # PTR configuration
      SOA_records: # SOA configuration
      SPF_records: # SPF configuration
      SRV_records: # SRV configuration
      SSHFP_records: # SSHFP configuration
      SVCB_records: # SVCB configuration
      TLSA_records: # TLSA configuration
      TXT_records: # TXT configuration
```
Each record type has a set of records with the following attributes
* `name`: The DNS name this record set will apply to
* `rrdatas` or one of `geo.rrdatas`/`wrr.rrdatas`: The string data for the records in this record set whose meaning depends on the DNS type.  
Optional attributes include:
* `ttl`: Time-to-live for record
* `geo`: For configuring a location based routing policy, contains the attributes `location` and `rrdatas`
* `wrr`: For configuring a weighted-round-robin routing policy, contains the attributes `weight` and `rrdatas`

### Example file
```yaml
components:
  common:
    project_id: project123456
    ttl: 300
  specs:
    private-zone:
      A_records:
        private.example.com:
          ttl: 180
          routing_policy:
            wrr:
              - weight: 0.2
                rrdatas:
                  - 192.168.0.2
              - weight: 0.8
                rrdatas:
                  - 192.168.0.3
      CNAME_records:
        www.example.com:
          rrdatas:
            - private.example.com.
    production-zone:
      project_id: project2345678
      A_records:
        prod.example.com:
          rrdatas: 
            - 198.51.100.3
            - 198.51.100.4
            - 198.51.100.5
      CNAME_records:
        frontend.prod.example.com:
          rrdatas:
            - frontend.example.com
            - www.example.com
        www.example.com:
          rrdatas:
            - frontend.prod.example.com
        frontend.example.com:
          rrdatas:
            - frontend.prod.example.com
    development-zone:
      A_records:
        dev.example.com:
          rrdatas:
            - 198.51.100.103
          geo:
            - location: europe-west2
              rrdatas:
                - 198.51.100.103
            - location: us-east1
              rrdatas:
                - 198.51.100.104
      CNAME_records:
        beta.example.com:
          rrdatas:
            - frontend.dev.example.com
        dev-frontend.example.com:
          rrdatas:
            - frontend.dev.example.com

```
