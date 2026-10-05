# Resume Page Standard — 2026-10-05

## Authoritative source

`Resume_Hazvinei_Masiya.md` remains the single cybersecurity-first content source. Regional PDFs must not introduce claims that are absent from that source.

## Page-count policy

| Market | Format | Maximum |
|---|---|---:|
| United States | Condensed ATS resume | 1 page |
| Canada | Condensed ATS resume | 1 page |
| Mexico | Condensed ATS resume | 1 page |
| Zimbabwe | Full resume | 2 pages |
| UK / Europe | Full resume / CV | 2 pages |
| Africa outside Zimbabwe | Full resume | 2 pages |
| Middle East | Full resume | 2 pages |
| Asia-Pacific | Full resume | 2 pages |
| Other international markets | Full resume | 2 pages |

## Evidence included

The resume explicitly includes four Forage virtual job simulations:
- Mastercard Cybersecurity Job Simulation — September 20, 2026
- Datacom Cyber Security Operations Job Simulation — September 20, 2026
- Deloitte Australia Cyber Job Simulation — October 4, 2026
- AIG Shields Up: Cybersecurity Job Simulation — October 4, 2026

These are labelled as virtual experience and are not presented as employment or client engagements.

## Quality rule

Page count is a hard constraint. Content should be shortened or prioritized before reducing readability. The North American version prioritizes security experience, recent professional experience, selected technical evidence, certifications, and all four virtual simulations.

Generated validation on 2026-10-05:
- Global master: 2 pages
- Zimbabwe: 2 pages
- UK/EU-style variants: 2 pages
- US: 1 page
- Canada: 1 page
- Mexico: 1 page


## Country-aware delivery architecture

The public resume selector uses the visitor's IP-derived ISO country code to choose a **country-specific published PDF first**, then a regional profile, then the two-page international fallback. North America is never the generic fallback.

The browser selects an already-reviewed published PDF; it does not invent or rewrite factual resume content. The authoritative content remains `Resume_Hazvinei_Masiya.md`, while country profiles control presentation, terminology, emphasis and page geometry.

Every published PDF downloads as:

`Hazvinei_Masiya_Resume.pdf`

## Current-format research gate

Country profiles are based on current 2026 resume/CV guidance and are reviewed before publication. The research for this release confirms that:

- Canadian guidance favours clear headings, reverse-chronological experience, readable formatting and concise resumes. Canada Job Bank recommends limiting a resume to two pages; this portfolio deliberately enforces the stricter one-page North American policy.
- Current UK guidance supports two pages for experienced candidates and recommends clear, professional, readable, ATS-friendly presentation.
- Current ATS/CV guidance favours simple structure, standard headings, readable fonts and job-relevant tailoring rather than decorative layouts.

Research sources reviewed: Indeed Canada resume guidance (2026), Canada Job Bank resume guidance, Indeed UK CV guidance (2026), and current Indeed ATS/CV formatting guidance.

The research gate is intentionally separated from visitor delivery: internet research may update a country profile, but a profile change cannot invent facts and must pass the PDF page validator before publication.

## Release acceptance criteria

1. IP country detection selects the explicit country profile when one exists.
2. Countries without a dedicated profile use the appropriate regional profile.
3. Unknown/unavailable country detection falls back to the two-page International Resume.
4. US, Canada and Mexico are exactly **1 page**.
5. All other country and regional variants are exactly **2 pages**.
6. Every published PDF downloads as `Hazvinei_Masiya_Resume.pdf`.
7. All four Forage simulations remain present in every published variant.
8. No country profile may introduce unsupported employment, qualifications, metrics, work authorisation, nationality, clearance or client claims.
