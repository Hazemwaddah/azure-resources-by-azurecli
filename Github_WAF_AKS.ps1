# Frontend
openssl ecparam -out frontend.key -name prime256v1 -genkey 
openssl req -new -sha256 -key frontend.key -out frontend.csr -subj "//CN=frontend" 
openssl x509 -req -sha256 -days 365 -in frontend.csr -signkey frontend.key -out frontend.crt


## Backend
openssl ecparam -out backend.key -name prime256v1 -genkey
openssl req -new -sha256 -key backend.key -out backend.csr -subj "//CN=backend"
openssl x509 -req -sha256 -days 365 -in backend.csr -signkey backend.key -out backend.crt


kubectl create secret tls frontend-tls --key="frontend.key" --cert="frontend.crt"
kubectl create secret tls backend-tls --key="backend.key" --cert="backend.crt"



kubectl exec -it website-deployment-766bc76dc8-vlfvs -- curl -k https://localhost:8443
kubectl exec -it  -- curl -k https://eptest.mycompany.com:9443
kubectl get pods

