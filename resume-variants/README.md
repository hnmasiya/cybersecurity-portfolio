# Automatic Country Resume Delivery

The portfolio uses one verified master resume and generates country-aware, two-page PDF variants.

## Visitor experience
Visitors see only **Download Resume**. The site detects the visitor's approximate country and silently selects the matching document.

Selection order:
1. Exact country profile
2. Regional profile
3. International profile

The detected country is used only to select presentation. It does **not** infer nationality, residence, work authorization, visa status, security clearance, eligibility, or any other personal attribute.

## Quality gate
Every generated PDF must be exactly **2 pages**. CI fails if any published variant is 1 or 3+ pages.

The master resume remains the single source of truth. Country profiles control page size and presentation conventions only; they do not invent or change qualifications, employment, certifications, or other factual claims.

## Profiles
Canada, United States, United Kingdom, Germany, France, Netherlands, Ireland, Switzerland, Australia, New Zealand, UAE, Qatar, Saudi Arabia, South Africa, Zimbabwe, Nigeria, Kenya, India, Singapore, Japan, South Korea, Brazil and Mexico, plus Europe, Africa, Middle East, Asia-Pacific and International fallbacks.
