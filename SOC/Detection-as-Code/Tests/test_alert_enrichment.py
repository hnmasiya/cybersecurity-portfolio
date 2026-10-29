import unittest

from automation.alert_enrichment import enrich_alert


class AlertEnrichmentTests(unittest.TestCase):
    def test_private_and_public_ip_classification(self):
        result = enrich_alert({"source_ip": "10.0.0.5", "destination_ip": "8.8.8.8"})
        indicators = result["enrichment"]["indicators"]
        self.assertEqual(indicators[0]["classification"], "private_or_local")
        self.assertEqual(indicators[1]["classification"], "public_ip_requires_reputation_lookup")
        self.assertFalse(result["enrichment"]["external_lookup_performed"])

    def test_ipv6_public_address_is_classified(self):
        result = enrich_alert({"remote_ip": "2001:4860:4860::8888"})
        indicator = result["enrichment"]["indicators"][0]
        self.assertEqual(indicator["classification"], "public_ip_requires_reputation_lookup")
        self.assertEqual(indicator["version"], "IPv6")

    def test_blank_ip_field_is_ignored(self):
        result = enrich_alert({"source_ip": "   ", "destination_ip": None})
        self.assertEqual(result["enrichment"]["indicators"], [])

    def test_invalid_ip_is_reported_not_raised(self):
        result = enrich_alert({"ip": "not-an-ip"})
        self.assertEqual(result["enrichment"]["indicators"][0]["classification"], "invalid_ip")

    def test_response_is_review_only(self):
        result = enrich_alert({"rule_id": "DE-001"})
        self.assertEqual(result["response_recommendation"]["action"], "review_only")
        self.assertFalse(result["response_recommendation"]["automatic_containment"])
        self.assertTrue(result["enrichment"]["analyst_review_required"])


if __name__ == "__main__":
    unittest.main()
