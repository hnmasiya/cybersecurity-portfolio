# Wazuh Detection Engineering — Lab 5

## Detection

**Rule ID:** 100500  
**Name:** lab5-detection-engineering  
**Severity:** 7

### Logic

The rule matches the controlled marker:

`LAB5-DETECTION-ENGINEERING`

### Validation

A positive test generated the marker and the Wazuh manager produced the
custom detection alert.

A negative test generated:

`LAB5-BENIGN-NONMATCH`

The negative marker does not contain the detection string and is expected
not to trigger the custom rule.

### SOC value

This exercise demonstrates:

- custom detection creation;
- controlled event generation;
- alert validation;
- rule-ID verification;
- positive testing;
- negative testing;
- basic false-positive control;
- evidence collection;
- detection documentation.

### Limitation

This is a deliberately narrow laboratory detection. It is not presented
as a production malicious-behavior rule.
