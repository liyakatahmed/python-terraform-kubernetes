from http.server import HTTPServer, SimpleHTTPRequestHandler

# Set the port number
PORT = 8000

# Create the HTTP server
server = HTTPServer(('', PORT), SimpleHTTPRequestHandler)
print(f'Server running on port {PORT}')

# Start the server
server.serve_forever()