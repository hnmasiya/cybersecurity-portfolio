/*
   YARA Rule: Detect Suspicious Credential Dumping Artifacts
   Author: Hazvinei Nomatter Masiya
*/

rule Detect_Suspicious_Memory_Dump {
    meta:
        author = "Hazvinei Nomatter Masiya"
        description = "Detects credentials dumping string patterns"
        date = "2026-08-22"
    strings:
        $s1 = "lsass.exe" nocase
        $s2 = "SeDebugPrivilege"
        $s3 = "MiniDumpWriteDump"
    condition:
        2 of ($s*)
}
