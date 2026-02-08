#!/usr/bin/env python3
"""Simple web server for dogFrame picture frame app.

Serves static files and provides API endpoints:
  GET  /api/photos  - list photos with weights
  POST /api/like    - increment a photo's weight
  POST /api/hide    - remove a photo from the library
"""

import json
import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8080
PHOTOS_DIR = "photos"
WEIGHTS_FILE = "weights.json"
IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".heic"}


def load_weights():
    if os.path.isfile(WEIGHTS_FILE):
        with open(WEIGHTS_FILE, "r") as f:
            return json.load(f)
    return {}


def save_weights(weights):
    with open(WEIGHTS_FILE, "w") as f:
        json.dump(weights, f, indent=2)


class DogFrameHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/api/photos":
            self.send_photo_list()
        else:
            super().do_GET()

    def do_POST(self):
        if self.path == "/api/like":
            self.handle_like()
        elif self.path == "/api/hide":
            self.handle_hide()
        else:
            self.send_response(404)
            self.end_headers()

    def read_body(self):
        length = int(self.headers.get("Content-Length", 0))
        if length == 0:
            return {}
        return json.loads(self.rfile.read(length))

    def send_json(self, data, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def send_photo_list(self):
        weights = load_weights()
        photos = []
        photos_path = os.path.join(os.getcwd(), PHOTOS_DIR)

        if os.path.isdir(photos_path):
            for filename in os.listdir(photos_path):
                ext = os.path.splitext(filename)[1].lower()
                if ext in IMAGE_EXTENSIONS:
                    path = "photos/" + filename
                    weight = weights.get(path, 1)
                    photos.append({"url": path, "weight": weight})

        photos.sort(key=lambda p: p["url"])
        self.send_json(photos)

    def handle_like(self):
        body = self.read_body()
        photo = body.get("photo", "")

        if not photo:
            self.send_json({"error": "Missing photo"}, 400)
            return

        weights = load_weights()
        weights[photo] = weights.get(photo, 1) + 1
        save_weights(weights)

        self.send_json({"photo": photo, "weight": weights[photo]})

    def handle_hide(self):
        body = self.read_body()
        photo = body.get("photo", "")

        if not photo:
            self.send_json({"error": "Missing photo"}, 400)
            return

        # Delete the file
        file_path = os.path.join(os.getcwd(), photo)
        if os.path.isfile(file_path):
            os.remove(file_path)

        # Remove from weights
        weights = load_weights()
        weights.pop(photo, None)
        save_weights(weights)

        self.send_json({"photo": photo, "removed": True})

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
