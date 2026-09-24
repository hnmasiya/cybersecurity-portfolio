from scripts import job_intelligence as ji


def make_job(title, description="security operations and SIEM"):
    return {
        "title": title,
        "company": "ExampleCo",
        "location": "Remote",
        "description": description,
        "category": "",
        "tags": "",
        "url": "https://example.test/job",
    }


def test_security_title_is_selected():
    result = ji.score(make_job("Security Operations Analyst"))
    assert result is not None
    assert result[0] > 0


def test_security_engineer_title_is_selected():
    result = ji.score(make_job("Backend Engineer (Security)"))
    assert result is not None


def test_product_security_title_is_selected():
    result = ji.score(make_job("Senior Product Security Engineer"))
    assert result is not None


def test_generic_business_role_is_rejected():
    result = ji.score(make_job("Business Analyst - Senior Consultant", "information security, SIEM"))
    assert result is None


def test_generic_data_role_is_rejected():
    result = ji.score(make_job("Staff Data Engineer", "incident response and SIEM"))
    assert result is None


def test_generic_backend_role_is_rejected_without_security_title_signal():
    result = ji.score(make_job("Senior Backend Engineer - Golang", "incident response"))
    assert result is None


def test_director_role_is_rejected():
    result = ji.score(make_job("Director, EMEA Professional Services | Luma", "SIEM"))
    assert result is None


def test_deduplication_key_collapses_duplicate_listing_variants():
    a = make_job("Senior Backend Engineer - Golang")
    b = make_job("Senior Backend Engineer - Golang")
    b["company"] = a["company"]
    b["location"] = a["location"]
    assert ji.dedupe_key(a) == ji.dedupe_key(b)
