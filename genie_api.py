import os
import base64
import hashlib
import hmac
import json
from datetime import datetime
from calendar import timegm

def get_nonce():
	random_part = base64.encodebytes(os.urandom(6)).strip().decode("utf-8")
	unix_timestamp = timegm(datetime.utcnow().utctimetuple())
	return f"{random_part}|{unix_timestamp}"

def get_signature(request_method, request_uri, request_payload, nonce, secret_key):
	to_sign = f"{request_method}{request_uri}{request_payload}{nonce}"
	return hmac.new(
	secret_key.encode("utf-8"), to_sign.encode("utf-8"), hashlib.sha256
	).hexdigest()

def handle_request(request):
	request_json = request.get_json()
	key_id = os.environ.get("PRACTO_SECRET_KEY_ID", "1")
	secret_key = os.environ.get("PRACTO_SECRET_KEY", "5GZXVE4LCpH5t2xTuxVq9m")
	request_method = "POST"
	request_uri ="https://subscriptions-uat.practodev.com/api/v1/partner/mahindra/subscriptions"
	request_payload = json.dumps(request_json)
	nonce = get_nonce()
	signature = get_signature(
	request_method, request_uri, request_payload, nonce, secret_key
	)
	authorization_header = (
	f"PRACTO-HMAC-SHA256 KeyId={key_id}, Nonce={nonce}, Signature={signature}"
	)
	print(authorization_header)
	return authorization_header
