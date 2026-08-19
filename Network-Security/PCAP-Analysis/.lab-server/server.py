from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)

        body = (
            "Controlled PCAP Analysis Lab\n"
            f"Path: {parsed.path}\n"
            f"Query: {parsed.query}\n"
        ).encode()

        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        return

HTTPServer(("127.0.0.1", 18080), Handler).serve_forever()
