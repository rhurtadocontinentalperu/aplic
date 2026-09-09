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

if __name__ == '__main__':
    #app.run(host= '0.0.0.0', port=51, debug=True)
    import subprocess
    #proc = subprocess.check_output("C:\\Progress\\OpenEdge\\bin\\prowin32.exe -b -db integral -U master -P 512283 -p web\api_stocks.p -param '000001|03' -H 192.168.100.209 -S 65010" ).decode('latin')
    proc = subprocess.check_output("C:\\Progress\\OpenEdge\\bin\\prowin32.exe -b -db integral -U master -P 512283 -p d:\\newsie\\on_in_co\\aplic\\web\\api_stocks.p -param 000545|03 -H 192.168.100.209 -S 65010" ).decode('latin')
    print (proc)
    print(jsonify({"message" : '%s'%(proc), "response": True}))
