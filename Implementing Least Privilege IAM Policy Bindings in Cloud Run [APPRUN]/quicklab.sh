

gcloud auth list

gcloud services enable run.googleapis.com

gcloud config set run/region $REGION

  gcloud run deploy billing-service \
  --image gcr.io/qwiklabs-resources/gsp723-parking-service \
  --region $REGION \
  --allow-unauthenticated

 BILLING_SERVICE_URL=$(gcloud run services list \
  --format='value(URL)' \
  --filter="billing-service")

curl -X POST -H "Content-Type: application/json" $BILLING_SERVICE_URL -d '{"userid": "1234", "minBalance": 100}'

sleep 10

 gcloud run deploy billing-service \
  --image gcr.io/qwiklabs-resources/gsp723-parking-service \
  --region $REGION \
  --no-allow-unauthenticated

 curl -X POST -H "Content-Type: application/json" $BILLING_SERVICE_URL -d '{"userid": "1234", "minBalance": 100}'

gcloud iam service-accounts create billing-initiator --display-name="Billing Initiator"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:billing-initiator@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/run.invoker"

 BILLING_INITIATOR_EMAIL=$(gcloud iam service-accounts list --filter="Billing Initiator" --format="value(EMAIL)"); echo $BILLING_INITIATOR_EMAIL

# Switch to second terminal 

 BILLING_INITIATOR_EMAIL=$(gcloud iam service-accounts list --filter="Billing Initiator" --format="value(EMAIL)"); echo $BILLING_INITIATOR_EMAIL

 BILLING_SERVICE_URL=$(gcloud run services list \
  --format='value(URL)' \
  --filter="billing-service")

gcloud iam service-accounts keys create key.json --iam-account=${BILLING_INITIATOR_EMAIL}

gcloud auth activate-service-account --key-file=key.json

 curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $BILLING_SERVICE_URL -d '{"userid": "1234", "minBalance": 500}'

sleep 5


# Switch to third terminal

 gcloud run deploy billing-service-2 \
  --image gcr.io/qwiklabs-resources/gsp723-parking-service \
  --region $REGION \
  --no-allow-unauthenticated

 BILLING_SERVICE_2_URL=$(gcloud run services list \
  --format='value(URL)' \
  --filter="billing-service-2")

gcloud auth activate-service-account --key-file=key.json


# Switch back to second terminal

 curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $BILLING_SERVICE_2_URL -d '{"userid": "1234", "minBalance": 900}'


# Switch back to first terminal

 BILLING_INITIATOR_EMAIL=$(gcloud iam service-accounts list --filter="Billing Initiator" --format="value(EMAIL)"); echo $BILLING_INITIATOR_EMAIL

gcloud projects remove-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:${BILLING_INITIATOR_EMAIL} \
  --role=roles/run.invoker


gcloud run services add-iam-policy-binding billing-service --region $REGION \
  --member=serviceAccount:${BILLING_INITIATOR_EMAIL} \
  --role=roles/run.invoker --platform managed


#  Switch back to second terminal

 curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $BILLING_SERVICE_URL -d '{"userid": "1234", "minBalance": 700}'


 curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $BILLING_SERVICE_2_URL -d '{"userid": "1234", "minBalance": 500}'


# Switch back to third terminal

 curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $BILLING_SERVICE_2_URL -d '{"userid": "1234", "minBalance": 500}'
