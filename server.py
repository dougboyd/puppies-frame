#!/usr/bin/env python3
"""Simple web server for dogFrame picture frame app.

Serves static files and provides a /api/photos endpoint
that returns a JSON list of photos in the photos/ directory.
"""

import json
import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8080
PHOTOS_DIR = "photos"
IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".heic"}


class DogFrameHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/api/photos":
            self.send_photo_list()
        else:
            super().do_GET()

    def send_photo_list(self):
        photos = []
        photos_path = os.path.join(os.getcwd(), PHOTOS_DIR)

        if os.path.isdir(photos_path):
            for filename in os.listdir(photos_path):
                ext = os.path.splitext(filename)[1].lower()
                if ext in IMAGE_EXTENSIONS:
                    photos.append("photos/" + filename)

        photos.sort()

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(photos).encode())

    def log_message(self, format, *args):
        client_ip = self.headers.get("CF-Connecting-IP", self.client_address[0])
        user_agent = self.headers.get("User-Agent", "-")
        print("[%s] %s %s \"%s\"" % (
            self.log_date_time_string(), client_ip, format % args, user_agent))


def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    if not os.path.isdir(PHOTOS_DIR):
        os.makedirs(PHOTOS_DIR)
        print("Created %s/ directory" % PHOTOS_DIR)

    server = HTTPServer(("0.0.0.0", PORT), DogFrameHandler)
    print("dogFrame server running on http://0.0.0.0:%d" % PORT)
    print("Photos directory: %s/" % os.path.abspath(PHOTOS_DIR))
    print("Press Ctrl+C to stop")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down...")
        server.shutdown()


if __name__ == "__main__":
    main()
