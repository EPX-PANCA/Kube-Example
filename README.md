Jika ingin menggunakan readinessprobe
di base url "misal 172.16.77.88:8080" harus 200 OK jika tidak 200 OK/ 404, maka pod tidak akan berjalan, karena yg di deteksi awal adalah base url, jika base url 404 maka akan di simpulkan adanya sebuah error.


Git Runner bisa menggunakan server sendiri (independent), untuk berkomunikasi dengan server kubernetes gitlab runner menggunakan kubeconfig (~/.kube/config)
Contoh:
 ```sh
 deploy_dev:
  stage: deploy_dev
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  script:
    - echo -n $KUBECONFIG_DEV | base64 -d > ./config
    - echo "Deploying service"
    - kubectl --kubeconfig ./config set image deployment/$SERVICE_NAME $SERVICE_NAME=$DOCKER_REPO:$CI_COMMIT_SHORT_SHA
    - echo "Service $SERVICE_NAME has been deployed to DEV"
    - sleep 100
    - kubectl --kubeconfig ./config get pods | grep gateway | awk '{print $1}' | xargs kubectl --kubeconfig ./config delete pod
    - echo "Gateway Service Restarted"
  only:
    - master

 ```
 
 
External service :
Jika ada sub domain maka sub domain juga di daftarkan, tidak hanya base domainnya saja, akan tetapi ketika mendaftarkan ut.ac.id, ternyata sub domain nya dapat di akses, misal aceh.ut.ac.id. akan tetapi untuk memastikan external service / external url dapat diakses, lebih baik sub domain di daftarkan/dibuat external servicenya.
