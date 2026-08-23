#!/usr/bin/env python3
import sys
import re

def sanitize_content(text):
    # Redact RFC1918 Private IPs
    text = re.sub(r'\b(10\.\d{1,3}\.\d{1,3}\.\d{1,3})\b', '[REDACTED_PRIVATE_IP]', text)
    text = re.sub(r'\b(172\.(1[6-9]|2[0-9]|3[0-1])\.\d{1,3}\.\d{1,3})\b', '[REDACTED_PRIVATE_IP]', text)
    text = re.sub(r'\b(192\.168\.\d{1,3}\.\d{1,3})\b', '[REDACTED_PRIVATE_IP]', text)
    
    # Redact potential API keys/tokens (32+ alphanumeric sequences)
    text = re.sub(r'(?i)(api[_-]?key|token|bearer|secret)[\s:=]+["\']?([a-zA-Z0-9_\-]{20,})["\']?', r'\1: [REDACTED_SECRET]', text)
    
    return text

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 sanitize-logs.py <file_path>")
        sys.exit(1)
        
    file_path = sys.argv[1]
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        sanitized = sanitize_content(content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(sanitized)
            
        print(f"[+] Successfully sanitized: {file_path}")
    except Exception as e:
        print(f"[-] Error processing {file_path}: {e}")
