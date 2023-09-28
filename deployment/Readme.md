Actions - 

1. Find all variables in kustomization patches and insert appropriate values.
2. Create a secret (by hand) to hold the AWS credentials.
    oc create secret generic creds --from-literal=AWS_ACCESS_KEY_ID=the-key --from-literal=AWS_SECRET_ACCESS_KEY=the-secret -n battleships-frontend
