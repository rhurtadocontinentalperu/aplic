from flask import Flask, request,jsonify
from flask_cors import CORS
app = Flask(__name__)
api_v1_cors_config = {
#   "origins": ["http://192.168.31.182:91"],
  "origins": "*",
  "methods": ["OPTIONS", "POST"],
  "allow_headers": ["Authorization", "Content-Type"]
}
CORS(app, resources={r"/api/progress_sunat": api_v1_cors_config})

app.secret_key = 'ContinentalSac2021'

@app.errorhandler(404)
def page_not_fount(err):
    return "404", 404

@app.errorhandler(403)
def page_not_fount_403(err):
    return "403", 403

@app.route("/", methods = ["GET"])
def home():
    return 'Welcome Progress.'

@app.route("/api/progress_sunat", methods = ["POST"])
def progress_sunat():
    proc = 'Error, not found'
    if request.method == "POST":
        import subprocess
        proc = subprocess.check_output("C:\\Progress\\OpenEdge\\bin\\_progres.exe -b -db integral -U userb2c -P b2c12345 -p Sunat\sunat-calculo-importe-b2c.p -H 192.168.100.209 -S 65010" ).decode('latin')
        print (proc)
        return jsonify({"message" : '%s'%(proc), "response": True})
    return jsonify({"message" : proc, "response": True})

if __name__ == '__main__':
    app.run(host= '0.0.0.0', port=51, debug=True)
