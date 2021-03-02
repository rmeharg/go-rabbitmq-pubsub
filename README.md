# RabbitMQ Pub/Sub Producer Consumer

A simple docker container that will receive messages from a RabbitMQ queue. The reciever will receive a single message at a time (per instance), and sleep for 1 second to simulate performing work.

## Setup

Clone the repo:

```cli
git clone https://github.com/rmeharg/go-rabbitmq-pubsub
cd go-rabbitmq-pubsub
```

### Creating a RabbitMQ queue

#### [Install Helm](https://helm.sh/docs/using_helm/)

#### Install RabbitMQ via Helm

Since the Helm stable repositoty was migrated to the Bitnami repository (https://github.com/helm/charts/tree/master/stable/rabbitmq), add the Bitnami repo and use it during the installation (bitnami/<chart> instead of stable/<chart>) 

```cli
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

##### Helm

RabbitMQ Helm Chart version 7.0.0 or later
```cli
helm install rabbitmq --set auth.username=user --set auth.password=PASSWORD bitnami/rabbitmq
```

#### Wait for RabbitMQ to deploy

⚠️ Be sure to wait until the deployment has completed before continuing. ⚠️

```cli
kubectl get po

NAME         READY   STATUS    RESTARTS   AGE
rabbitmq-0   1/1     Running   0          3m3s
```

### Deploying a RabbitMQ consumer

#### Deploy a consumer
```cli
kubectl apply -f deploy/deploy-consumer.yaml
```

#### Validate the consumer has deployed
```cli
kubectl get deploy
```

You should see `rabbitmq-consumer` deployment with 0 pods as there currently aren't any queue messages.  It is scale to zero.

```
NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rabbitmq-consumer   0         0         0            0           3s
```

[This consumer](https://github.com/rmeharg/go-rabbitmq-pubsub/blob/master/cmd/receive/receive.go) is set to consume one message per instance, sleep for 1 second, and then acknowledge completion of the message.  This is used to simulate work.

### Publishing messages to the queue

#### Deploy the publisher job

The following job will publish 300 messages to the "hello" queue the deployment is listening to. You can modify the exact number of published messages in the `deploy-publisher-job.yaml` file.

```cli
kubectl apply -f deploy/deploy-publisher-job.yaml
```

## Cleanup resources

```cli
kubectl delete job rabbitmq-publish
kubectl delete deploy rabbitmq-consumer
helm delete rabbitmq
```
