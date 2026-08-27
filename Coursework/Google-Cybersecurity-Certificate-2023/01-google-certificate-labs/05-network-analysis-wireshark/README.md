# Network Traffic Analysis with Wireshark

## Overview & Summary
* **Lab Context:** Google Cybersecurity Professional Certificate Module.
* **Summary:** In this lab, I analyzed packet capture files (`.pcap`) within Wireshark to inspect network communications at the packet level. I applied display filters (`http`, `tcp.flags.syn == 1`, `dns`) to unmask cleartext authentication credentials transmitted over HTTP. The findings highlighted critical unencrypted protocol risks, leading to recommendations for implementing mandatory TLS/HTTPS encryption.
